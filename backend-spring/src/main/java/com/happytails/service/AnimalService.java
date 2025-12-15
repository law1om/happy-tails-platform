package com.happytails.service;

import com.happytails.dto.AnimalDto;
import com.happytails.dto.request.CreateAnimalRequest;
import com.happytails.entity.Animal;
import com.happytails.entity.Photo;
import com.happytails.exception.ResourceNotFoundException;
import com.happytails.mapper.AnimalMapper;
import com.happytails.entity.Shelter;
import com.happytails.repository.AnimalRepository;
import com.happytails.repository.ShelterRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AnimalService {
    
    private final AnimalRepository animalRepository;
    private final AnimalMapper animalMapper;
    private final ShelterRepository shelterRepository;
    
    @Transactional(readOnly = true)
    public List<AnimalDto> getAllAnimals() {
        return animalRepository.findAll().stream()
                .map(animalMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public AnimalDto getAnimalById(Long id) {
        Animal animal = animalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + id));
        return animalMapper.toDto(animal);
    }
    
    @Transactional(readOnly = true)
    public List<AnimalDto> getAnimalsByType(Animal.AnimalType type) {
        return animalRepository.findByType(type).stream()
                .map(animalMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional(readOnly = true)
    public List<AnimalDto> getAnimalsByStatus(Animal.AnimalStatus status) {
        return animalRepository.findByStatus(status).stream()
                .map(animalMapper::toDto)
                .collect(Collectors.toList());
    }
    
    @Transactional
    public AnimalDto createAnimal(CreateAnimalRequest request) {
        Animal animal = Animal.builder()
                .name(request.getName())
                .age(request.getAge())
                .weight(request.getWeight())
                .breed(request.getBreed())
                .type(request.getType())
                .description(request.getDescription())
                .status(Animal.AnimalStatus.AVAILABLE)
                .build();
        
        if (request.getShelterId() != null) {
            Shelter shelter = shelterRepository.findById(request.getShelterId())
                    .orElseThrow(() -> new ResourceNotFoundException("Shelter not found with id: " + request.getShelterId()));
            animal.setShelter(shelter);
        }
        
        if (request.getPhotoUrls() != null && !request.getPhotoUrls().isEmpty()) {
            for (int i = 0; i < request.getPhotoUrls().size(); i++) {
                Photo photo = Photo.builder()
                        .url(request.getPhotoUrls().get(i))
                        .displayOrder(i)
                        .build();
                animal.addPhoto(photo);
            }
        }
        
        animal = animalRepository.save(animal);
        return animalMapper.toDto(animal);
    }
    
    @Transactional
    public AnimalDto updateAnimal(Long id, CreateAnimalRequest request) {
        Animal animal = animalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + id));
        
        animal.setName(request.getName());
        animal.setAge(request.getAge());
        animal.setWeight(request.getWeight());
        animal.setBreed(request.getBreed());
        animal.setType(request.getType());
        animal.setDescription(request.getDescription());
        
        if (request.getShelterId() != null) {
            Shelter shelter = shelterRepository.findById(request.getShelterId())
                    .orElseThrow(() -> new ResourceNotFoundException("Shelter not found with id: " + request.getShelterId()));
            animal.setShelter(shelter);
        }
        
        if (request.getPhotoUrls() != null) {
            animal.getPhotos().clear();
            for (int i = 0; i < request.getPhotoUrls().size(); i++) {
                Photo photo = Photo.builder()
                        .url(request.getPhotoUrls().get(i))
                        .displayOrder(i)
                        .build();
                animal.addPhoto(photo);
            }
        }
        
        animal = animalRepository.save(animal);
        return animalMapper.toDto(animal);
    }
    
    @Transactional
    public void deleteAnimal(Long id) {
        Animal animal = animalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + id));
        animalRepository.delete(animal);
    }
    
    @Transactional
    public AnimalDto updateAnimalStatus(Long id, Animal.AnimalStatus status) {
        Animal animal = animalRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Animal not found with id: " + id));
        animal.setStatus(status);
        animal = animalRepository.save(animal);
        return animalMapper.toDto(animal);
    }
}
