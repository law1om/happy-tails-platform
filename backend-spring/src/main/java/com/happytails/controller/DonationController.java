package com.happytails.controller;

import com.happytails.dto.DonationDto;
import com.happytails.dto.request.CreateDonationRequest;
import com.happytails.dto.response.ApiResponse;
import com.happytails.security.UserPrincipal;
import com.happytails.service.DonationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/donations")
@RequiredArgsConstructor
public class DonationController {
    
    private final DonationService donationService;
    
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<DonationDto>>> getAllDonations() {
        List<DonationDto> donations = donationService.getAllDonations();
        return ResponseEntity.ok(ApiResponse.success(donations));
    }
    
    @GetMapping("/my")
    public ResponseEntity<ApiResponse<List<DonationDto>>> getMyDonations(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        List<DonationDto> donations = donationService.getDonationsByUserId(currentUser.getId());
        return ResponseEntity.ok(ApiResponse.success(donations));
    }
    
    @GetMapping("/animal/{animalId}")
    public ResponseEntity<ApiResponse<List<DonationDto>>> getDonationsByAnimal(@PathVariable Long animalId) {
        List<DonationDto> donations = donationService.getDonationsByAnimalId(animalId);
        return ResponseEntity.ok(ApiResponse.success(donations));
    }
    
    @GetMapping("/event/{eventId}")
    public ResponseEntity<ApiResponse<List<DonationDto>>> getDonationsByEvent(@PathVariable Long eventId) {
        List<DonationDto> donations = donationService.getDonationsByEventId(eventId);
        return ResponseEntity.ok(ApiResponse.success(donations));
    }
    
    @PostMapping
    public ResponseEntity<ApiResponse<DonationDto>> createDonation(
            @Valid @RequestBody CreateDonationRequest request,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        DonationDto donation = donationService.createDonation(currentUser.getId(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Donation created successfully", donation));
    }
    
    @GetMapping("/total")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<BigDecimal>> getTotalDonations() {
        BigDecimal total = donationService.getTotalDonations();
        return ResponseEntity.ok(ApiResponse.success(total));
    }
    
    @GetMapping("/total/animal/{animalId}")
    public ResponseEntity<ApiResponse<BigDecimal>> getTotalDonationsForAnimal(@PathVariable Long animalId) {
        BigDecimal total = donationService.getTotalDonationsForAnimal(animalId);
        return ResponseEntity.ok(ApiResponse.success(total));
    }
    
    @GetMapping("/total/event/{eventId}")
    public ResponseEntity<ApiResponse<BigDecimal>> getTotalDonationsForEvent(@PathVariable Long eventId) {
        BigDecimal total = donationService.getTotalDonationsForEvent(eventId);
        return ResponseEntity.ok(ApiResponse.success(total));
    }
    
    @PostMapping("/payment-intent")
    public ResponseEntity<ApiResponse<DonationDto>> createPaymentIntent(
            @Valid @RequestBody CreateDonationRequest request,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        DonationDto donation = donationService.createPaymentIntent(currentUser.getId(), request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Payment intent created. Please complete payment.", donation));
    }
    
    @PostMapping("/{id}/confirm")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<DonationDto>> confirmPayment(
            @PathVariable Long id,
            @RequestParam String transactionId) {
        DonationDto donation = donationService.confirmPayment(id, transactionId);
        return ResponseEntity.ok(ApiResponse.success("Payment confirmed", donation));
    }
    
    @PostMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<DonationDto>> cancelPayment(
            @PathVariable Long id,
            @AuthenticationPrincipal UserPrincipal currentUser) {
        DonationDto donation = donationService.cancelPayment(id);
        return ResponseEntity.ok(ApiResponse.success("Payment cancelled", donation));
    }
}
