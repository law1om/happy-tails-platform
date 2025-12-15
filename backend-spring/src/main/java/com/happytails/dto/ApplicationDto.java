package com.happytails.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApplicationDto {
    private Long id;
    private Long userId;
    private String userName;
    private String userEmail;
    private Long animalId;
    private String animalName;
    private String animalSpecies;
    private Long adoptionProfileId;
    private String status;
    private String adminComment;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
