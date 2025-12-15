package com.happytails.dto.request;

import com.happytails.entity.Animal;
import jakarta.validation.constraints.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateAnimalRequest {
    
    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    private String name;
    
    @NotNull(message = "Age is required")
    @Min(value = 0, message = "Age must be positive")
    @Max(value = 30, message = "Age must be less than 30")
    private Integer age;
    
    @NotNull(message = "Weight is required")
    @DecimalMin(value = "0.1", message = "Weight must be positive")
    @DecimalMax(value = "200.0", message = "Weight must be less than 200kg")
    private Double weight;
    
    @NotBlank(message = "Breed is required")
    @Size(max = 100, message = "Breed must be at most 100 characters")
    private String breed;
    
    @NotNull(message = "Type is required")
    private Animal.AnimalType type;
    
    @Size(max = 2000, message = "Description must be at most 2000 characters")
    private String description;
    
    private Long shelterId;
    
    @Size(min = 1, max = 5, message = "Photos must be between 1 and 5")
    private List<String> photoUrls;
}
