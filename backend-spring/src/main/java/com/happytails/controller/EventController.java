package com.happytails.controller;

import com.happytails.dto.EventDto;
import com.happytails.dto.request.CreateEventRequest;
import com.happytails.dto.response.ApiResponse;
import com.happytails.entity.Event;
import com.happytails.security.UserPrincipal;
import com.happytails.service.EventService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/events")
@RequiredArgsConstructor
public class EventController {
    
    private final EventService eventService;
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<EventDto>>> getAllEvents() {
        List<EventDto> events = eventService.getAllEvents();
        return ResponseEntity.ok(ApiResponse.success(events));
    }
    
    @GetMapping("/my")
    public ResponseEntity<ApiResponse<List<EventDto>>> getMyEvents() {
        // Возвращаем все предстоящие события для пользователя
        List<EventDto> events = eventService.getUpcomingEvents();
        return ResponseEntity.ok(ApiResponse.success(events));
    }
    
    @GetMapping("/upcoming")
    public ResponseEntity<ApiResponse<List<EventDto>>> getUpcomingEvents() {
        List<EventDto> events = eventService.getUpcomingEvents();
        return ResponseEntity.ok(ApiResponse.success(events));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<EventDto>> getEventById(@PathVariable Long id) {
        EventDto event = eventService.getEventById(id);
        return ResponseEntity.ok(ApiResponse.success(event));
    }
    
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<EventDto>>> getEventsByStatus(@PathVariable Event.EventStatus status) {
        List<EventDto> events = eventService.getEventsByStatus(status);
        return ResponseEntity.ok(ApiResponse.success(events));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<EventDto>> createEvent(@Valid @RequestBody CreateEventRequest request) {
        EventDto event = eventService.createEvent(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Event created successfully", event));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<EventDto>> updateEvent(
            @PathVariable Long id,
            @Valid @RequestBody CreateEventRequest request) {
        EventDto event = eventService.updateEvent(id, request);
        return ResponseEntity.ok(ApiResponse.success("Event updated successfully", event));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteEvent(@PathVariable Long id) {
        eventService.deleteEvent(id);
        return ResponseEntity.ok(ApiResponse.success("Event deleted successfully", null));
    }
    
    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<EventDto>> updateEventStatus(
            @PathVariable Long id,
            @RequestParam Event.EventStatus status) {
        EventDto event = eventService.updateEventStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Event status updated successfully", event));
    }
    
    @PostMapping("/{id}/register")
    public ResponseEntity<ApiResponse<EventDto>> registerForEvent(
            @PathVariable Long id,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        EventDto event = eventService.registerForEvent(id, currentUser.getId());
        return ResponseEntity.ok(ApiResponse.success("Successfully registered for event", event));
    }
    
    @PostMapping("/{id}/unregister")
    public ResponseEntity<ApiResponse<EventDto>> unregisterFromEvent(
            @PathVariable Long id,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        EventDto event = eventService.unregisterFromEvent(id, currentUser.getId());
        return ResponseEntity.ok(ApiResponse.success("Successfully unregistered from event", event));
    }
    
    @GetMapping("/{id}/is-registered")
    public ResponseEntity<ApiResponse<Boolean>> isUserRegistered(
            @PathVariable Long id,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        boolean isRegistered = eventService.isUserRegistered(id, currentUser.getId());
        return ResponseEntity.ok(ApiResponse.success(isRegistered));
    }
}
