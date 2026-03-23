export default function Home() {
  // Next.js (Server Side) bisa baca env apa pun dari Docker Run
  const name = process.env.APP_NAME; 
  const version = process.env.APP_VERSION;

  return (
    <div>
      <h1>HELLOW WOOOOORLD OF DESTRUCTION!</h1>
    </div>
  );
}