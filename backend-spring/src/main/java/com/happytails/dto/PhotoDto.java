package com.happytails.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PhotoDto {
    private Long id;
    private String url;
    private Integer displayOrder;
}
