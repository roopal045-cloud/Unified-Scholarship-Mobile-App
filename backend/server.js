const express = require("express");
const cors = require("cors");

const authRoutes = require("./src/routes/auth");
const applicationRoutes = require("./src/routes/applications");
const verificationRoutes = require("./src/routes/verification");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Route mounting - this decides the URL prefix for each route file.
app.use("/api/auth", authRoutes);
app.use("/api/applications", applicationRoutes);
app.use("/api/verification", verificationRoutes);

// Simple health check - useful to confirm the server is alive.
app.get("/", (req, res) => {
  res.json({ status: "Unified Scholarship API is running" });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});