package com.happytails.mapper;

import com.happytails.dto.ApplicationDto;
import com.happytails.entity.Application;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface ApplicationMapper {
    
    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "user.fullName", target = "userName")
    @Mapping(source = "user.email", target = "userEmail")
    @Mapping(source = "animal.id", target = "animalId")
    @Mapping(source = "animal.name", target = "animalName")
    @Mapping(source = "animal.type", target = "animalSpecies")
    @Mapping(source = "adoptionProfile.id", target = "adoptionProfileId")
    ApplicationDto toDto(Application application);
    
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "animal", ignore = true)
    @Mapping(target = "adoptionProfile", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    Application toEntity(ApplicationDto applicationDto);
}
