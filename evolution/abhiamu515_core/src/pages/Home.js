import React from 'react';
import styled from 'styled-components';
import Button from '../components/common/Button';
import useFetch from '../hooks/useFetch';

const HomeContainer = styled.div`
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
`;

const Hero = styled.div`
  text-align: center;
  margin-bottom: 3rem;
  
  h1 {
    font-size: 2.5rem;
    margin-bottom: 1rem;
  }
  
  p {
    font-size: 1.2rem;
    color: #666;
    max-width: 600px;
    margin: 0 auto 2rem;
  }
`;

const PostsGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
`;

const PostCard = styled.div`
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  background-color: white;
  
  h2 {
    margin-top: 0;
    font-size: 1.4rem;
  }
  
  p {
    color: #666;
  }
`;

const Home = () => {
  const { data: posts, loading, error } = useFetch('https://jsonplaceholder.typicode.com/posts?_limit=6');

  return (
    <HomeContainer>
      <Hero>
        <h1>Welcome to Your New React App</h1>
        <p>
          This is a starter template with React Router, Axios, and Styled Components.
          Edit the files to start building your application.
        </p>
        <Button>Get Started</Button>
      </Hero>
      
      <h2>Latest Posts</h2>
      
      {loading && <p>Loading posts...</p>}
      {error && <p>Error loading posts: {error}</p>}
      
      {posts && (
        <PostsGrid>
          {posts.map(post => (
            <PostCard key={post.id}>
              <h2>{post.title}</h2>
              <p>{post.body}</p>
            </PostCard>
          ))}
        </PostsGrid>
      )}
    </HomeContainer>
  );
};

export default Home;
