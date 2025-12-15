package com.happytails.service;

import com.happytails.dto.AdoptionProfileDto;
import com.happytails.entity.AdoptionProfile;
import com.happytails.entity.User;
import com.happytails.exception.BadRequestException;
import com.happytails.exception.ResourceNotFoundException;
import com.happytails.mapper.AdoptionProfileMapper;
import com.happytails.repository.AdoptionProfileRepository;
import com.happytails.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AdoptionProfileService {
    
    private final AdoptionProfileRepository adoptionProfileRepository;
    private final UserRepository userRepository;
    private final AdoptionProfileMapper adoptionProfileMapper;
    
    @Transactional
    public AdoptionProfileDto createProfile(Long userId, AdoptionProfileDto profileDto) {
        if (adoptionProfileRepository.existsByUserId(userId)) {
            throw new BadRequestException("Adoption profile already exists for this user");
        }
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
        
        AdoptionProfile profile = adoptionProfileMapper.toEntity(profileDto);
        profile.setUser(user);
        profile.setStatus("PENDING");
        
        AdoptionProfile savedProfile = adoptionProfileRepository.save(profile);
        return adoptionProfileMapper.toDto(savedProfile);
    }
    
    @Transactional(readOnly = true)
    public AdoptionProfileDto getMyProfile(Long userId) {
        AdoptionProfile profile = adoptionProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Adoption profile not found"));
        return adoptionProfileMapper.toDto(profile);
    }
    
    @Transactional
    public AdoptionProfileDto updateProfile(Long userId, AdoptionProfileDto profileDto) {
        AdoptionProfile profile = adoptionProfileRepository.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("Adoption profile not found"));
        
        // Update fields
        profile.setHousingType(profileDto.getHousingType());
        profile.setHasYard(profileDto.getHasYard());
        profile.setHasOtherPets(profileDto.getHasOtherPets());
        profile.setOtherPetsDescription(profileDto.getOtherPetsDescription());
        profile.setHasChildren(profileDto.getHasChildren());
        profile.setChildrenCount(profileDto.getChildrenCount());
        profile.setExperience(profileDto.getExperience());
        profile.setWorkSchedule(profileDto.getWorkSchedule());
        profile.setAddress(profileDto.getAddress());
        profile.setPhone(profileDto.getPhone());
        profile.setAdditionalInfo(profileDto.getAdditionalInfo());
        
        AdoptionProfile updatedProfile = adoptionProfileRepository.save(profile);
        return adoptionProfileMapper.toDto(updatedProfile);
    }
}
