package com.happytails.repository;

import com.happytails.entity.Donation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface DonationRepository extends JpaRepository<Donation, Long> {
    
    List<Donation> findByUserId(Long userId);
    
    List<Donation> findByAnimalId(Long animalId);
    
    List<Donation> findByEventId(Long eventId);
    
    @Query("SELECT SUM(d.amount) FROM Donation d WHERE d.animal.id = :animalId")
    BigDecimal sumByAnimalId(Long animalId);
    
    @Query("SELECT SUM(d.amount) FROM Donation d WHERE d.event.id = :eventId")
    BigDecimal sumByEventId(Long eventId);
    
    @Query("SELECT SUM(d.amount) FROM Donation d WHERE d.shelter.id = :shelterId")
    BigDecimal sumByShelterId(Long shelterId);
    
    @Query("SELECT SUM(d.amount) FROM Donation d")
    BigDecimal sumAllDonations();
}
