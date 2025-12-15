package com.happytails.service;

import com.happytails.dto.EventDto;
import com.happytails.dto.request.CreateEventRequest;
import com.happytails.entity.Event;
import com.happytails.entity.EventRegistration;
import com.happytails.entity.User;
import com.happytails.exception.BadRequestException;
import com.happytails.exception.ResourceNotFoundException;
import com.happytails.mapper.EventMapper;
import com.happytails.repository.EventRegistrationRepository;
import com.happytails.repository.EventRepository;
import com.happytails.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class EventService {
    
    private final EventRepository eventRepository;
    private final EventRegistrationRepository eventRegistrationRepository;
    private final UserRepository userRepository;
    private final EventMapper eventMapper;
    
    @Transactional(readOnly = true)
    public List<EventDto> getAllEvents() {
        return eventRepository.findAll().stream()
                .map(eventMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public EventDto getEventById(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));
        return eventMapper.toDto(event);
    }
    
    @Transactional(readOnly = true)
    public List<EventDto> getUpcomingEvents() {
        return eventRepository.findByEventDateAfter(LocalDateTime.now()).stream()
                .map(eventMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<EventDto> getEventsByStatus(Event.EventStatus status) {
        return eventRepository.findByStatus(status).stream()
                .map(eventMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public EventDto createEvent(CreateEventRequest request) {
        Event.EventStatus status = Event.EventStatus.UPCOMING;
        if (request.getStatus() != null) {
            try {
                status = Event.EventStatus.valueOf(request.getStatus().toUpperCase());
            } catch (IllegalArgumentException e) {
                status = Event.EventStatus.UPCOMING;
            }
        }
        
        Event event = Event.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .eventDate(request.getEventDate())
                .location(request.getLocation())
                .maxParticipants(request.getMaxParticipants())
                .currentParticipants(0)
                .imageUrl(request.getImageUrl())
                .targetAmount(request.getTargetAmount())
                .currentAmount(BigDecimal.ZERO)
                .status(status)
                .build();
        
        event = eventRepository.save(event);
        return eventMapper.toDto(event);
    }
    
    @Transactional
    public EventDto updateEvent(Long id, CreateEventRequest request) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));
        
        event.setTitle(request.getTitle());
        event.setDescription(request.getDescription());
        event.setEventDate(request.getEventDate());
        event.setLocation(request.getLocation());
        event.setMaxParticipants(request.getMaxParticipants());
        event.setImageUrl(request.getImageUrl());
        event.setTargetAmount(request.getTargetAmount());
        
        if (request.getStatus() != null) {
            try {
                Event.EventStatus status = Event.EventStatus.valueOf(request.getStatus().toUpperCase());
                event.setStatus(status);
            } catch (IllegalArgumentException e) {
                // Keep existing status if invalid
            }
        }
        
        event = eventRepository.save(event);
        return eventMapper.toDto(event);
    }
    
    @Transactional
    public void deleteEvent(Long id) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));
        eventRepository.delete(event);
    }
    
    @Transactional
    public EventDto updateEventStatus(Long id, Event.EventStatus status) {
        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + id));
        event.setStatus(status);
        event = eventRepository.save(event);
        return eventMapper.toDto(event);
    }
    
    @Transactional
    public EventDto registerForEvent(Long eventId, Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        
        // Проверяем, не зарегистрирован ли пользователь уже
        if (eventRegistrationRepository.existsByUserIdAndEventId(userId, eventId)) {
            throw new BadRequestException("You are already registered for this event");
        }
        
        // Проверяем количество мест
        Long confirmedCount = eventRegistrationRepository.countConfirmedByEventId(eventId);
        if (confirmedCount >= event.getMaxParticipants()) {
            throw new BadRequestException("Event is full");
        }
        
        // Создаем регистрацию
        EventRegistration registration = EventRegistration.builder()
                .user(user)
                .event(event)
                .status(EventRegistration.RegistrationStatus.CONFIRMED)
                .build();
        
        eventRegistrationRepository.save(registration);
        
        // Обновляем счетчик участников
        event.setCurrentParticipants(confirmedCount.intValue() + 1);
        event = eventRepository.save(event);
        
        return eventMapper.toDto(event);
    }
    
    @Transactional
    public EventDto unregisterFromEvent(Long eventId, Long userId) {
        Event event = eventRepository.findById(eventId)
                .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + eventId));
        
        // Проверяем, зарегистрирован ли пользователь
        EventRegistration registration = eventRegistrationRepository.findByUserIdAndEventId(userId, eventId)
                .orElseThrow(() -> new BadRequestException("You are not registered for this event"));
        
        // Удаляем регистрацию
        eventRegistrationRepository.delete(registration);
        
        // Обновляем счетчик участников
        Long confirmedCount = eventRegistrationRepository.countConfirmedByEventId(eventId);
        event.setCurrentParticipants(confirmedCount.intValue());
        event = eventRepository.save(event);
        
        return eventMapper.toDto(event);
    }
    
    @Transactional(readOnly = true)
    public boolean isUserRegistered(Long eventId, Long userId) {
        return eventRegistrationRepository.existsByUserIdAndEventId(userId, eventId);
    }
}
