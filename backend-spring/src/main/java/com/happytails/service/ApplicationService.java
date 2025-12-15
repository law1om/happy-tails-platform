package com.happytails.service;

import com.happytails.dto.ApplicationDto;
import com.happytails.entity.AdoptionProfile;
import com.happytails.entity.Animal;
import com.happytails.entity.Application;
import com.happytails.entity.User;
import com.happytails.exception.BadRequestException;
import com.happytails.exception.ResourceNotFoundException;
import com.happytails.mapper.ApplicationMapper;
import com.happytails.repository.AdoptionProfileRepository;
import com.happytails.repository.AnimalRepository;
import com.happytails.repository.ApplicationRepository;
import com.happytails.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ApplicationService {
    
    private final ApplicationRepository applicationRepository;
    private final UserRepository userRepository;
    private final AnimalRepository animalRepository;
    private final AdoptionProfileRepository adoptionProfileRepository;
    private final ApplicationMapper applicationMapper;
    
    @Transactional
    public ApplicationDto createApplication(Long userId, Long animalId) {
        // Check if user already applied for this animal
        if (applicationRepository.existsByUserIdAndAnimalId(userId, animalId)) {
            throw new BadRequestException("You have already applied for this animal");
        }
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        
        Animal animal = animalRepository.findById(animalId)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found"));
        
        // Check if user has an adoption profile
        AdoptionProfile profile = adoptionProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new BadRequestException("Please create an adoption profile first"));
        
        Application application = Application.builder()
                .user(user)
                .animal(animal)
                .adoptionProfile(profile)
                .status("PENDING")
                .build();
        
        Application savedApplication = applicationRepository.save(application);
        return applicationMapper.toDto(savedApplication);
    }
    
    @Transactional(readOnly = true)
    public List<ApplicationDto> getMyApplications(Long userId) {
        List<Application> applications = applicationRepository.findByUserId(userId);
        return applications.stream()
                .map(applicationMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<ApplicationDto> getAllApplications() {
        List<Application> applications = applicationRepository.findAll();
        return applications.stream()
                .map(applicationMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public ApplicationDto updateApplicationStatus(Long applicationId, String status, String adminComment) {
        Application application = applicationRepository.findById(applicationId)
                .orElseThrow(() -> new ResourceNotFoundException("Application not found"));
        
        application.setStatus(status);
        application.setAdminComment(adminComment);
        
        Application updatedApplication = applicationRepository.save(application);
        return applicationMapper.toDto(updatedApplication);
    }
}
