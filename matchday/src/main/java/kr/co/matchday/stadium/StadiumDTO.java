package kr.co.matchday.stadium;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class StadiumDTO {

	private String stadiumId;
    private String stadiumName;
    private String location;
    private int capacity;
    private String usageStatus;
    private int parkingSpaces;
    private byte[] stadiumImage;
    private String contactNumber;
	
}
