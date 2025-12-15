package com.happytails.controller;

import com.happytails.dto.ApplicationDto;
import com.happytails.dto.response.ApiResponse;
import com.happytails.security.UserPrincipal;
import com.happytails.service.ApplicationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/applications")
@RequiredArgsConstructor
public class ApplicationController {
    
    private final ApplicationService applicationService;
    
    @PostMapping
    public ResponseEntity<ApiResponse<ApplicationDto>> createApplication(
            @AuthenticationPrincipal UserPrincipal currentUser,
            @RequestBody Map<String, Long> request) {
        Long animalId = request.get("animalId");
        ApplicationDto application = applicationService.createApplication(currentUser.getId(), animalId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Application submitted successfully", application));
    }
    
    @GetMapping("/my")
    public ResponseEntity<ApiResponse<List<ApplicationDto>>> getMyApplications(
            @AuthenticationPrincipal UserPrincipal currentUser) {
        List<ApplicationDto> applications = applicationService.getMyApplications(currentUser.getId());
        return ResponseEntity.ok(ApiResponse.success("Applications retrieved successfully", applications));
    }
    
    @GetMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<List<ApplicationDto>>> getAllApplications() {
        List<ApplicationDto> applications = applicationService.getAllApplications();
        return ResponseEntity.ok(ApiResponse.success("Applications retrieved successfully", applications));
    }
    
    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ApplicationDto>> updateApplicationStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        String status = request.get("status");
        String adminComment = request.get("adminComment");
        ApplicationDto application = applicationService.updateApplicationStatus(id, status, adminComment);
        return ResponseEntity.ok(ApiResponse.success("Application status updated successfully", application));
    }
}
