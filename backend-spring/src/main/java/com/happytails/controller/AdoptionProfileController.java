package com.happytails.controller;

import com.happytails.dto.AdoptionProfileDto;
import com.happytails.dto.response.ApiResponse;
import com.happytails.security.UserPrincipal;
import com.happytails.service.AdoptionProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/adoption-profiles")
@RequiredArgsConstructor
public class AdoptionProfileController {
    
    private final AdoptionProfileService adoptionProfileService;
    
    @PostMapping
    public ResponseEntity<ApiResponse<AdoptionProfileDto>> createProfile(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @RequestBody AdoptionProfileDto profileDto) {
        AdoptionProfileDto createdProfile = adoptionProfileService.createProfile(currentUser.getId(), profileDto);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Adoption profile created successfully", createdProfile));
    }
    
    @GetMapping("/my")
    public ResponseEntity<ApiResponse<AdoptionProfileDto>> getMyProfile(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        AdoptionProfileDto profile = adoptionProfileService.getMyProfile(currentUser.getId());
        return ResponseEntity.ok(ApiResponse.success("Profile retrieved successfully", profile));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<AdoptionProfileDto>> updateProfile(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @PathVariable Long id,
            @RequestBody AdoptionProfileDto profileDto) {
        AdoptionProfileDto updatedProfile = adoptionProfileService.updateProfile(currentUser.getId(), profileDto);
        return ResponseEntity.ok(ApiResponse.success("Profile updated successfully", updatedProfile));
    }
}
