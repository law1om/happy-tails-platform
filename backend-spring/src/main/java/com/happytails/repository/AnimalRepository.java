package com.happytails.repository;

import com.happytails.entity.Animal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AnimalRepository extends JpaRepository<Animal, Long> {
    
    List<Animal> findByType(Animal.AnimalType type);
    
    List<Animal> findByStatus(Animal.AnimalStatus status);
    
    @Query("SELECT a FROM Animal a LEFT JOIN FETCH a.photos WHERE a.id = :id")
    Animal findByIdWithPhotos(Long id);
}
