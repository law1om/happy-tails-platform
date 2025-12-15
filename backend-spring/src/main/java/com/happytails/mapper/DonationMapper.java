package com.happytails.mapper;

import com.happytails.dto.DonationDto;
import com.happytails.entity.Donation;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface DonationMapper {
    
    @Mapping(source = "user.id", target = "userId")
    @Mapping(source = "user.fullName", target = "userName")
    @Mapping(source = "animal.id", target = "animalId")
    @Mapping(source = "animal.name", target = "animalName")
    @Mapping(source = "event.id", target = "eventId")
    @Mapping(source = "event.title", target = "eventTitle")
    @Mapping(source = "shelter.id", target = "shelterId")
    @Mapping(source = "shelter.name", target = "shelterName")
    DonationDto toDto(Donation donation);
    
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "animal", ignore = true)
    @Mapping(target = "event", ignore = true)
    @Mapping(target = "shelter", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    Donation toEntity(DonationDto donationDto);
}
