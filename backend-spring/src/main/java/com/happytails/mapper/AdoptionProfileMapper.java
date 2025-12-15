package com.happytails.mapper;

import com.happytails.dto.AdoptionProfileDto;
import com.happytails.entity.AdoptionProfile;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface AdoptionProfileMapper {
    
    @Mapping(source = "user.id", target = "userId")
    AdoptionProfileDto toDto(AdoptionProfile adoptionProfile);
    
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    AdoptionProfile toEntity(AdoptionProfileDto adoptionProfileDto);
}
