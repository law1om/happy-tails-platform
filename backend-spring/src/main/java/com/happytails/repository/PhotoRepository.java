package com.happytails.repository;

import com.happytails.entity.Photo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PhotoRepository extends JpaRepository<Photo, Long> {
    
    List<Photo> findByAnimalIdOrderByDisplayOrderAsc(Long animalId);
    
    void deleteByAnimalId(Long animalId);
}
