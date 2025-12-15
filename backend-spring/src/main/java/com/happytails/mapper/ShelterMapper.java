package com.happytails.mapper;

import com.happytails.dto.ShelterDto;
import com.happytails.entity.Shelter;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ShelterMapper {
    
    @Mapping(target = "animalCount", expression = "java(shelter.getAnimals() != null ? shelter.getAnimals().size() : 0)")
    ShelterDto toDto(Shelter shelter);
    
    @Mapping(target = "animals", ignore = true)
    @Mapping(target = "donations", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    Shelter toEntity(ShelterDto shelterDto);
}
