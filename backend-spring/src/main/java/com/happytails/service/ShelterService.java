package com.happytails.service;

import com.happytails.dto.ShelterDto;
import com.happytails.dto.request.CreateShelterRequest;
import com.happytails.entity.Shelter;
import com.happytails.exception.ResourceNotFoundException;
import com.happytails.mapper.ShelterMapper;
import com.happytails.repository.ShelterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ShelterService {
    
    private final ShelterRepository shelterRepository;
    private final ShelterMapper shelterMapper;
    
    public List<ShelterDto> getAllShelters() {
        return shelterRepository.findAll().stream()
                .map(shelterMapper::toDto)
                .collect(Collectors.toList());
    }
    
    public ShelterDto getShelterById(Long id) {
        Shelter shelter = shelterRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Shelter not found with id: " + id));
        return shelterMapper.toDto(shelter);
    }
    
    @Transactional
    public ShelterDto createShelter(CreateShelterRequest request) {
        Shelter shelter = Shelter.builder()
                .name(request.getName())
                .description(request.getDescription())
                .address(request.getAddress())
                .phone(request.getPhone())
                .email(request.getEmail())
                .bankAccount(request.getBankAccount())
                .build();
        
        shelter = shelterRepository.save(shelter);
        return shelterMapper.toDto(shelter);
    }
    
    @Transactional
    public ShelterDto updateShelter(Long id, CreateShelterRequest request) {
        Shelter shelter = shelterRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Shelter not found with id: " + id));
        
        shelter.setName(request.getName());
        shelter.setDescription(request.getDescription());
        shelter.setAddress(request.getAddress());
        shelter.setPhone(request.getPhone());
        shelter.setEmail(request.getEmail());
        shelter.setBankAccount(request.getBankAccount());
        
        shelter = shelterRepository.save(shelter);
        return shelterMapper.toDto(shelter);
    }
    
    @Transactional
    public void deleteShelter(Long id) {
        if (!shelterRepository.existsById(id)) {
            throw new ResourceNotFoundException("Shelter not found with id: " + id);
        }
        shelterRepository.deleteById(id);
    }
}
