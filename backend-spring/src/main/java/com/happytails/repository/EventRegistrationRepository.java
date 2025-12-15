package com.happytails.repository;

import com.happytails.entity.EventRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EventRegistrationRepository extends JpaRepository<EventRegistration, Long> {
    
    boolean existsByUserIdAndEventId(Long userId, Long eventId);
    
    Optional<EventRegistration> findByUserIdAndEventId(Long userId, Long eventId);
    
    List<EventRegistration> findByUserId(Long userId);
    
    List<EventRegistration> findByEventId(Long eventId);
    
    @Query("SELECT COUNT(er) FROM EventRegistration er WHERE er.event.id = :eventId AND er.status = 'CONFIRMED'")
    Long countConfirmedByEventId(Long eventId);
    
    void deleteByUserIdAndEventId(Long userId, Long eventId);
}
