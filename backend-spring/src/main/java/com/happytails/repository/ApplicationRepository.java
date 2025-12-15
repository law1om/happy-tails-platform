package com.happytails.repository;

import com.happytails.entity.Application;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ApplicationRepository extends JpaRepository<Application, Long> {
    List<Application> findByUserId(Long userId);
    List<Application> findByAnimalId(Long animalId);
    boolean existsByUserIdAndAnimalId(Long userId, Long animalId);
}
