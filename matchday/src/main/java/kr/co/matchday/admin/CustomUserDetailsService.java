/*
 * package kr.co.matchday.admin;
 * 
 * import org.springframework.security.core.userdetails.UserDetails; import
 * org.springframework.security.core.userdetails.UserDetailsService; import
 * org.springframework.security.core.userdetails.UsernameNotFoundException;
 * import org.springframework.security.core.GrantedAuthority; import
 * org.springframework.security.core.authority.SimpleGrantedAuthority; import
 * org.springframework.stereotype.Service;
 * 
 * import javax.sql.DataSource; import java.sql.Connection; import
 * java.sql.PreparedStatement; import java.sql.ResultSet; import
 * java.sql.SQLException; import java.util.ArrayList; import
 * java.util.Collection;
 * 
 * @Service public class CustomUserDetailsService implements UserDetailsService
 * {
 * 
 * private final DataSource dataSource;
 * 
 * public CustomUserDetailsService(DataSource dataSource) { this.dataSource =
 * dataSource; }
 * 
 * @Override public UserDetails loadUserByUsername(String username) throws
 * UsernameNotFoundException { try (Connection connection =
 * dataSource.getConnection()) { String userQuery =
 * "SELECT userid, password FROM users WHERE userid = ?"; String
 * authoritiesQuery = "SELECT grade FROM users WHERE userid = ?";
 * 
 * PreparedStatement userStmt = connection.prepareStatement(userQuery);
 * userStmt.setString(1, username); ResultSet userRs = userStmt.executeQuery();
 * 
 * if (!userRs.next()) { throw new UsernameNotFoundException("User not found");
 * }
 * 
 * String password = userRs.getString("password");
 * 
 * PreparedStatement authoritiesStmt =
 * connection.prepareStatement(authoritiesQuery); authoritiesStmt.setString(1,
 * username); ResultSet authoritiesRs = authoritiesStmt.executeQuery();
 * 
 * Collection<GrantedAuthority> authorities = new ArrayList<>(); while
 * (authoritiesRs.next()) { String grade = authoritiesRs.getString("grade");
 * authorities.add(new SimpleGrantedAuthority("ROLE_" + grade)); // 'ROLE_' 접두사를
 * 붙여서 권한 설정 }
 * 
 * return new org.springframework.security.core.userdetails.User(username,
 * password, authorities); } catch (SQLException e) { throw new
 * UsernameNotFoundException("Database error", e); } } }
 */