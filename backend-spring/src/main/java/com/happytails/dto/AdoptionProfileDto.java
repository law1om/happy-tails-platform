package com.happytails.dto;

import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdoptionProfileDto {
    private Long id;
    private Long userId;
    private String housingType;
    private Boolean hasYard;
    private Boolean hasOtherPets;
    private String otherPetsDescription;
    private Boolean hasChildren;
    private Integer childrenCount;
    private String experience;
    private String workSchedule;
    private String address;
    private String phone;
    private String additionalInfo;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
