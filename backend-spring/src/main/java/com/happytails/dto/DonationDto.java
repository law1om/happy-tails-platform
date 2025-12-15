package com.happytails.dto;

import com.happytails.entity.Donation;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DonationDto {
    private Long id;
    private Long userId;
    private String userName;
    private BigDecimal amount;
    private Long animalId;
    private String animalName;
    private Long eventId;
    private String eventTitle;
    private Long shelterId;
    private String shelterName;
    private String message;
    private Donation.DonationStatus status;
    private LocalDateTime createdAt;
}
