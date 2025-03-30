import express, { type Request, type Response } from "express";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

//^ User management
app.post("/api/auth/login", (req: Request, res: Response) => {
    res.json({
        message: "Login route"
    })
});

app.get("/api/auth/profile", (req: Request, res: Response) => {
    res.json({
        message: "Profile route"
    })
});

//^ User database configs
app.post("/api/database/config", (req: Request, res: Response) => {

});

app.get("/auth/database/config", (req: Request, res: Response) => {

});

//^ Indexing categories
app.get("/api/indexing/categories", (req: Request, res: Response) => {

});

app.get("/api/indexing/categories/:id", (req: Request, res: Response) => {

});


//^ Indexing preferences
app.post('/api/indexing/preferences', (req: Request, res: Response) => {

});

app.get('/api/indexing/preferences', (req: Request, res: Response) => {
    
});

//^ Indexing jobs
app.post("/api/indexing/jobs", (req: Request, res: Response) => {

})

app.get("/api/jobs/:id", (req: Request, res: Response) => {
    
})

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
})