package com.happytails.mapper;

import com.happytails.dto.AnimalDto;
import com.happytails.entity.Animal;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = {PhotoMapper.class})
public interface AnimalMapper {
    @Mapping(target = "shelterId", source = "shelter.id")
    @Mapping(target = "shelterName", source = "shelter.name")
    AnimalDto toDto(Animal animal);
    
    @Mapping(target = "donations", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "shelter", ignore = true)
    Animal toEntity(AnimalDto animalDto);
}
