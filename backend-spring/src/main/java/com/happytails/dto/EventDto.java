package com.happytails.dto;

import com.happytails.entity.Event;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EventDto {
    private Long id;
    private String title;
    private String description;
    private LocalDateTime eventDate;
    private String location;
    private Integer maxParticipants;
    private Integer currentParticipants;
    private String imageUrl;
    private BigDecimal targetAmount;
    private BigDecimal currentAmount;
    private Event.EventStatus status;
    private LocalDateTime createdAt;
}
