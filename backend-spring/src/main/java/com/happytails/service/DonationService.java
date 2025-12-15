package com.happytails.service;

import com.happytails.dto.DonationDto;
import com.happytails.dto.request.CreateDonationRequest;
import com.happytails.entity.Animal;
import com.happytails.entity.Donation;
import com.happytails.entity.Event;
import com.happytails.entity.Shelter;
import com.happytails.entity.User;
import com.happytails.exception.BadRequestException;
import com.happytails.exception.ResourceNotFoundException;
import com.happytails.mapper.DonationMapper;
import com.happytails.repository.AnimalRepository;
import com.happytails.repository.DonationRepository;
import com.happytails.repository.EventRepository;
import com.happytails.repository.ShelterRepository;
import com.happytails.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class DonationService {
    
    private final DonationRepository donationRepository;
    private final UserRepository userRepository;
    private final AnimalRepository animalRepository;
    private final EventRepository eventRepository;
    private final ShelterRepository shelterRepository;
    private final DonationMapper donationMapper;
    
    @Transactional(readOnly = true)
    public List<DonationDto> getAllDonations() {
        return donationRepository.findAll().stream()
                .map(donationMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<DonationDto> getDonationsByUserId(Long userId) {
        return donationRepository.findByUserId(userId).stream()
                .map(donationMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<DonationDto> getDonationsByAnimalId(Long animalId) {
        return donationRepository.findByAnimalId(animalId).stream()
                .map(donationMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<DonationDto> getDonationsByEventId(Long eventId) {
        return donationRepository.findByEventId(eventId).stream()
                .map(donationMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public DonationDto createDonation(Long userId, CreateDonationRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        
        if (request.getAnimalId() == null && request.getEventId() == null && request.getShelterId() == null) {
            throw new BadRequestException("Donation must be associated with an animal, event, or shelter");
        }
        
        Donation donation = Donation.builder()
                .user(user)
                .amount(request.getAmount())
                .message(request.getMessage())
                .status(Donation.DonationStatus.PENDING) // Изначально статус PENDING
                .paymentMethod(request.getPaymentMethod())
                .build();
        
        if (request.getAnimalId() != null) {
            Animal animal = animalRepository.findById(request.getAnimalId())
                    .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + request.getAnimalId()));
            donation.setAnimal(animal);
        }
        
        if (request.getEventId() != null) {
            Event event = eventRepository.findById(request.getEventId())
                    .orElseThrow(() -> new ResourceNotFoundException("Event not found with id: " + request.getEventId()));
            donation.setEvent(event);
            
            // Update event current amount
            event.setCurrentAmount(event.getCurrentAmount().add(request.getAmount()));
            eventRepository.save(event);
        }
        
        if (request.getShelterId() != null) {
            Shelter shelter = shelterRepository.findById(request.getShelterId())
                    .orElseThrow(() -> new ResourceNotFoundException("Shelter not found with id: " + request.getShelterId()));
            donation.setShelter(shelter);
        }
        
        donation = donationRepository.save(donation);
        return donationMapper.toDto(donation);
    }
    
    @Transactional(readOnly = true)
    public BigDecimal getTotalDonations() {
        BigDecimal total = donationRepository.sumAllDonations();
        return total != null ? total : BigDecimal.ZERO;
    }
    
    @Transactional(readOnly = true)
    public BigDecimal getTotalDonationsForAnimal(Long animalId) {
        BigDecimal total = donationRepository.sumByAnimalId(animalId);
        return total != null ? total : BigDecimal.ZERO;
    }
    
    @Transactional(readOnly = true)
    public BigDecimal getTotalDonationsForEvent(Long eventId) {
        BigDecimal total = donationRepository.sumByEventId(eventId);
        return total != null ? total : BigDecimal.ZERO;
    }
    
    /**
     * Создает намерение платежа (для интеграции с Stripe/PayPal)
     * В реальном приложении здесь будет вызов API платежной системы
     */
    @Transactional
    public DonationDto createPaymentIntent(Long userId, CreateDonationRequest request) {
        // Создаем пожертвование со статусом PENDING
        DonationDto donation = createDonation(userId, request);
        
        // TODO: Интеграция с Stripe/PayPal
        // String paymentIntentId = stripeService.createPaymentIntent(donation.getAmount());
        // String paymentUrl = stripeService.getPaymentUrl(paymentIntentId);
        // 
        // Donation entity = donationRepository.findById(donation.getId()).orElseThrow();
        // entity.setPaymentIntentId(paymentIntentId);
        // entity.setPaymentUrl(paymentUrl);
        // donationRepository.save(entity);
        
        return donation;
    }
    
    /**
     * Подтверждает платеж (вызывается webhook'ом от платежной системы)
     */
    @Transactional
    public DonationDto confirmPayment(Long donationId, String transactionId) {
        Donation donation = donationRepository.findById(donationId)
                .orElseThrow(() -> new ResourceNotFoundException("Donation not found with id: " + donationId));
        
        donation.setStatus(Donation.DonationStatus.COMPLETED);
        donation.setTransactionId(transactionId);
        donation = donationRepository.save(donation);
        
        return donationMapper.toDto(donation);
    }
    
    /**
     * Отменяет платеж
     */
    @Transactional
    public DonationDto cancelPayment(Long donationId) {
        Donation donation = donationRepository.findById(donationId)
                .orElseThrow(() -> new ResourceNotFoundException("Donation not found with id: " + donationId));
        
        donation.setStatus(Donation.DonationStatus.CANCELLED);
        donation = donationRepository.save(donation);
        
        return donationMapper.toDto(donation);
    }
    
    /**
     * Помечает платеж как неудачный
     */
    @Transactional
    public DonationDto failPayment(Long donationId) {
        Donation donation = donationRepository.findById(donationId)
                .orElseThrow(() -> new ResourceNotFoundException("Donation not found with id: " + donationId));
        
        donation.setStatus(Donation.DonationStatus.FAILED);
        donation = donationRepository.save(donation);
        
        return donationMapper.toDto(donation);
    }
}
