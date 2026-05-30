__DOTENV_IMPORT__
import app from "./app";

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`__PROJECT_TITLE__ server is running on port ${PORT}`);
});
