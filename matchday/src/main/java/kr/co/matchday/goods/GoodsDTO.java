package kr.co.matchday.goods;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class GoodsDTO {

	private String goodsid; // 굿즈 ID
	private String category; // 굿즈 카테고리
	private String productname; // 상품명
	private String description; // 설명
	private String size; // 사이즈
	private int price; // 가격
	private int stockquantity; // 재고 수량
	private String issoldout; // 품절 여부
	private String filename; // 파일 이름
	private long filesize; // 파일 크기
	
	// Getters and setters
	public String getGoodsid() {
		return goodsid;
	}
	public void setGoodsid(String goodsid) {
		this.goodsid = goodsid;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getProductname() {
		return productname;
	}
	public void setProductname(String productname) {
		this.productname = productname;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getSize() {
		return size;
	}
	public void setSize(String size) {
		this.size = size;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getStockquantity() {
		return stockquantity;
	}
	public void setStockquantity(int stockquantity) {
		this.stockquantity = stockquantity;
	}
	public String getIssoldout() {
		return issoldout;
	}
	public void setIssoldout(String issoldout) {
		this.issoldout = issoldout;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public long getFilesize() {
		return filesize;
	}
	public void setFilesize(long filesize) {
		this.filesize = filesize;
	}
	
	
	
}//class end
