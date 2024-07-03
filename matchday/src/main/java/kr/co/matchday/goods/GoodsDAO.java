package kr.co.matchday.goods;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class GoodsDAO {

	public GoodsDAO() {
		System.out.println("-----GoodsDAO() 객체 생성됨");
	}//end
	
	@Autowired
	private SqlSession sqlSession;
	
	public void insert(GoodsDTO goodsDto) {
	    sqlSession.insert("goods.insert", goodsDto);
	}//insert end

	public List<GoodsDTO> list() {
	    return sqlSession.selectList("goods.list");
	}//list end

	public List<GoodsDTO> search(String productname) { 
	    return sqlSession.selectList("goods.search", "%" + productname + "%");
	}//search end

	public GoodsDTO detail(String goodsid) {
	    return sqlSession.selectOne("goods.detail", goodsid);
	}//detail end

	public void update(GoodsDTO goodsDto) {
	    sqlSession.update("goods.update", goodsDto);
	}//update end

	public void delete(String goodsid) {
	    sqlSession.delete("goods.delete", goodsid);
	}//delete end

	public String filename(String goodsid) {
	    return sqlSession.selectOne("goods.filename", goodsid);
	}//filename end
	
	public List<GoodsDTO> listWithPaging(Map<String, Integer> params) {
        return sqlSession.selectList("goods.listWithPaging", params);
    }//listWithPaging end

    public int countGoods() {
        return sqlSession.selectOne("goods.countGoods");
    }//countGoods end
	
	
	
	
	
}//class end
