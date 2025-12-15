package com.happytails.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "animals")
@EntityListeners(AuditingEntityListener.class)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Animal {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private Integer age;
    
    @Column(nullable = false)
    private Double weight;
    
    @Column(nullable = false)
    private String breed;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private AnimalType type;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    @Builder.Default
    private AnimalStatus status = AnimalStatus.AVAILABLE;
    
    @OneToMany(mappedBy = "animal", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<Photo> photos = new ArrayList<>();
    
    @OneToMany(mappedBy = "animal", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Donation> donations = new ArrayList<>();
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "shelter_id")
    private Shelter shelter;
    
    @CreatedDate
    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;
    
    @LastModifiedDate
    private LocalDateTime updatedAt;
    
    public enum AnimalType {
        CAT, DOG
    }
    
    public enum AnimalStatus {
        AVAILABLE, ADOPTED, RESERVED
    }
    
    public void addPhoto(Photo photo) {
        photos.add(photo);
        photo.setAnimal(this);
    }
    
    public void removePhoto(Photo photo) {
        photos.remove(photo);
        photo.setAnimal(null);
    }
}
