package com.happytails.mapper;

import com.happytails.dto.EventDto;
import com.happytails.entity.Event;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface EventMapper {
    EventDto toDto(Event event);
    @Mapping(target = "donations", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    Event toEntity(EventDto eventDto);
}
