package kr.co.matchday.admin;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class PointMasterDTO {
	private int pointcategoryid;
    private String pointcategoryname;
    private Integer accumulatedpoints;
    private Double rate;
}
