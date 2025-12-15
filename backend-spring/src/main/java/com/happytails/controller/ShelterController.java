package com.happytails.controller;

import com.happytails.dto.ShelterDto;
import com.happytails.dto.request.CreateShelterRequest;
import com.happytails.dto.response.ApiResponse;
import com.happytails.service.ShelterService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shelters")
@RequiredArgsConstructor
public class ShelterController {
    
    private final ShelterService shelterService;
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<ShelterDto>>> getAllShelters() {
        List<ShelterDto> shelters = shelterService.getAllShelters();
        return ResponseEntity.ok(ApiResponse.success(shelters));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<ShelterDto>> getShelterById(@PathVariable Long id) {
        ShelterDto shelter = shelterService.getShelterById(id);
        return ResponseEntity.ok(ApiResponse.success(shelter));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ShelterDto>> createShelter(@Valid @RequestBody CreateShelterRequest request) {
        ShelterDto shelter = shelterService.createShelter(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Shelter created successfully", shelter));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ShelterDto>> updateShelter(
            @PathVariable Long id,
            @Valid @RequestBody CreateShelterRequest request) {
        ShelterDto shelter = shelterService.updateShelter(id, request);
        return ResponseEntity.ok(ApiResponse.success("Shelter updated successfully", shelter));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteShelter(@PathVariable Long id) {
        shelterService.deleteShelter(id);
        return ResponseEntity.ok(ApiResponse.success("Shelter deleted successfully", null));
    }
}
