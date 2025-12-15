package com.happytails.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Table(name = "adoption_profiles")
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AdoptionProfile {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(name = "housing_type", nullable = false)
    private String housingType; // APARTMENT, HOUSE, FARM
    
    @Column(name = "has_yard")
    private Boolean hasYard;
    
    @Column(name = "has_other_pets")
    private Boolean hasOtherPets;
    
    @Column(name = "other_pets_description")
    private String otherPetsDescription;
    
    @Column(name = "has_children")
    private Boolean hasChildren;
    
    @Column(name = "children_count")
    private Integer childrenCount;
    
    @Column(name = "experience", nullable = false)
    private String experience; // NONE, SOME, EXPERIENCED
    
    @Column(name = "work_schedule", nullable = false)
    private String workSchedule;
    
    @Column(name = "address", nullable = false)
    private String address;
    
    @Column(name = "phone", nullable = false)
    private String phone;
    
    @Column(name = "additional_info", columnDefinition = "TEXT")
    private String additionalInfo;
    
    @Column(name = "status", nullable = false)
    private String status; // PENDING, APPROVED, REJECTED
    
    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
