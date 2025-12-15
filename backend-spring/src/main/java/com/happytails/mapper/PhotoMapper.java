package com.happytails.mapper;

import com.happytails.dto.PhotoDto;
import com.happytails.entity.Photo;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface PhotoMapper {
    PhotoDto toDto(Photo photo);
    @Mapping(target = "animal", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    Photo toEntity(PhotoDto photoDto);
}
