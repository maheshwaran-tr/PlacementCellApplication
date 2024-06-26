import { application } from "express";
import { Proofs } from "../models/job_models/proofModel.js";

export const getProof = async (req, res) => {
  try {
    const { applicationId } = req.params;
    const proof = await Proofs.findOne({ application: applicationId });
    if (!proof || !proof.proofImage) {
      return res.status(404).send("Proof not found");
    }

    res.set("Content-Type", "image/jpeg");
    // Serve the image file
    res.sendFile(proof.proofImage, { root: "uploads/application_proofs" });

  } catch (error) {
    console.error("Error fetching proof:", error);
    res.status(500).send("Failed to fetch proof");
  }
};

export const uploadProof = async (req, res) => {

  try {
    const newProof = new Proofs({
      application: req.body.application,
      proofImage: req.file.filename,
    });

    const exsistingProof = await Proofs.find({application : req.body.application});
    
    if(exsistingProof){
      return res.status(409).json({ message: "Proof already exists" });
    }
    const savedProof = await newProof.save();

    res.status(200).send("Proof uploaded successfully");
  } catch (error) {
    console.error("Error uploading proof:", error);
    res.status(500).send("Failed to upload proof");
  }
};
