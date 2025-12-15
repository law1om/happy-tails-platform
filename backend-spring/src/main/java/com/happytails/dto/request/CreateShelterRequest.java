package com.happytails.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateShelterRequest {
    
    @NotBlank(message = "Name is required")
    private String name;
    
    private String description;
    
    private String address;
    
    private String phone;
    
    @Email(message = "Invalid email format")
    private String email;
    
    private String bankAccount;
}
