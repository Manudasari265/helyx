import { Helius } from "helius-sdk";
import dotenv from "dotenv";

dotenv.config();

const HELIUS_API_KEY = process.env.HELIUS_API_KEY as string;

const helius = new Helius(HELIUS_API_KEY);

export default helius;