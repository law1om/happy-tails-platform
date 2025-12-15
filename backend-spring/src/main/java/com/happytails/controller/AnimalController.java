package com.happytails.controller;

import com.happytails.dto.AnimalDto;
import com.happytails.dto.request.CreateAnimalRequest;
import com.happytails.dto.response.ApiResponse;
import com.happytails.entity.Animal;
import com.happytails.service.AnimalService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/animals")
@RequiredArgsConstructor
public class AnimalController {
    
    private final AnimalService animalService;
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<AnimalDto>>> getAllAnimals() {
        List<AnimalDto> animals = animalService.getAllAnimals();
        return ResponseEntity.ok(ApiResponse.success(animals));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<AnimalDto>> getAnimalById(@PathVariable Long id) {
        AnimalDto animal = animalService.getAnimalById(id);
        return ResponseEntity.ok(ApiResponse.success(animal));
    }
    
    @GetMapping("/type/{type}")
    public ResponseEntity<ApiResponse<List<AnimalDto>>> getAnimalsByType(@PathVariable Animal.AnimalType type) {
        List<AnimalDto> animals = animalService.getAnimalsByType(type);
        return ResponseEntity.ok(ApiResponse.success(animals));
    }
    
    @GetMapping("/status/{status}")
    public ResponseEntity<ApiResponse<List<AnimalDto>>> getAnimalsByStatus(@PathVariable Animal.AnimalStatus status) {
        List<AnimalDto> animals = animalService.getAnimalsByStatus(status);
        return ResponseEntity.ok(ApiResponse.success(animals));
    }
    
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<AnimalDto>> createAnimal(@Valid @RequestBody CreateAnimalRequest request) {
        AnimalDto animal = animalService.createAnimal(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Animal created successfully", animal));
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<AnimalDto>> updateAnimal(
            @PathVariable Long id,
            @Valid @RequestBody CreateAnimalRequest request) {
        AnimalDto animal = animalService.updateAnimal(id, request);
        return ResponseEntity.ok(ApiResponse.success("Animal updated successfully", animal));
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteAnimal(@PathVariable Long id) {
        animalService.deleteAnimal(id);
        return ResponseEntity.ok(ApiResponse.success("Animal deleted successfully", null));
    }
    
    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<AnimalDto>> updateAnimalStatus(
            @PathVariable Long id,
            @RequestParam Animal.AnimalStatus status) {
        AnimalDto animal = animalService.updateAnimalStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Animal status updated successfully", animal));
    }
}
