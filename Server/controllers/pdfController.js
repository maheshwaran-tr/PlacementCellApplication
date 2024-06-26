import { Student } from "../models/student_models/studentModel.js";
import PDFDocument from "pdfkit-table";
import fs from "fs";

export const generatePdfStudents = async (req, res) => {
  try {
    // Fetch students from the database
    const students = await Student.find();

    // Create a new PDF document
    let doc = new PDFDocument({ margin: 30, size: "A4" });

    // Set the response to download the PDF
    res.setHeader("Content-Disposition", "attachment; filename=students.pdf");
    res.setHeader("Content-Type", "application/pdf");

    // Pipe the PDF into the response
    doc.pipe(res);

    // Add the logo
    const logoPath = "D:/PlacementCellApp/Server/assets/sit_logo.png"; // replace with your logo path
    if (fs.existsSync(logoPath)) {
      doc.image(logoPath, {
        fit: [70, 40],
        align: "center",
        valign: "center",
      });
    }

    // Add the college name
    doc.font("Times-Bold").fontSize(15).text("SETHU INSTITUTE OF TECHNOLOGY", {
      align: "center",
    });
    doc.moveDown(0.5);

    // Add the subheading
    const subheading =
      "An Autonomous Institution | Accredited with A++ Grade by NAAC\n" +
      "Permanently Affiliated to Anna University Chennai, Approved by AICTE - New Delhi";
    doc.font("Times-Roman").fontSize(10).text(subheading, {
      align: "center",
    });
    doc.moveDown(2);

    // Add the current date
    const currentDate = new Date().toLocaleDateString();
    doc.font("Times-Roman").fontSize(10).text(`Date: ${currentDate}`, {
      align: "right",
    });
    doc.moveDown(1);

    const jobDetails = "Applied Students for Zoho";
    doc.font("Times-Bold").fontSize(12).text(jobDetails, {
      align: "center"
    });
    doc.moveDown(1);

    // Create a table with the student data
    const table = {
      headers: ["Register Number", "Name", "Phone Number", "Email"],
      rows: students.map((student) => [
        student.regNo,
        student.studentName,
        student.phoneNumber,
        student.email,
      ]),
    };

    // Add the table to the PDF document
    doc.table(table, {
      prepareHeader: () => doc.font("Helvetica-Bold").fontSize(8),
      prepareRow: (row, indexColumn, indexRow, rectRow, rectCell) => {
        doc.font("Helvetica").fontSize(8);
        indexColumn === 0 && doc.addBackground(rectRow, "blue", 0.15);
      },
    });

    // Finalize the PDF and end the stream
    doc.end();
  } catch (error) {
    res.status(500).send("Error generating PDF");
    console.error(error);
  }
};
