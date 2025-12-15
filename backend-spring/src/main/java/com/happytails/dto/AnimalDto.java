package com.happytails.dto;

import com.happytails.entity.Animal;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AnimalDto {
    private Long id;
    private String name;
    private Integer age;
    private Double weight;
    private String breed;
    private Animal.AnimalType type;
    private String description;
    private Animal.AnimalStatus status;
    private List<PhotoDto> photos;
    private Long shelterId;
    private String shelterName;
    private LocalDateTime createdAt;
}
