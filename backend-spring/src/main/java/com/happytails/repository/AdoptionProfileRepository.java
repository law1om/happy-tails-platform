package com.happytails.repository;

import com.happytails.entity.AdoptionProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdoptionProfileRepository extends JpaRepository<AdoptionProfile, Long> {
    Optional<AdoptionProfile> findByUserId(Long userId);
    boolean existsByUserId(Long userId);
}
