export default function Home() {
  // Next.js (Server Side) bisa baca env apa pun dari Docker Run
  const name = process.env.APP_NAME; 
  const version = process.env.APP_VERSION;

  return (
    <div>
      <h1>App: {name}</h1>
      <p>Version: {version}</p>
    </div>
  );
}