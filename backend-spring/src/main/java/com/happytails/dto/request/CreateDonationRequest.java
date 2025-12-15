package com.happytails.dto.request;

import com.happytails.entity.Donation;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateDonationRequest {
    
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "1.0", message = "Amount must be at least 1")
    @DecimalMax(value = "1000000.0", message = "Amount must be less than 1,000,000")
    private BigDecimal amount;
    
    private Long animalId;
    
    private Long eventId;
    
    private Long shelterId;
    
    @Size(max = 500, message = "Message must be at most 500 characters")
    private String message;
    
    private Donation.PaymentMethod paymentMethod;
}
