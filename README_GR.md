# CAD for Digital H/W (E-CAD)
## Εργαστηριακές Ασκήσεις Ψηφιακού Σχεδιασμού

Το παρόν αποθετήριο περιέχει το σύνολο των εργαστηριακών ασκήσεων του μαθήματος
**Σχεδίαση Συστημάτων με Χρήση Υπολογιστών (CAD for Digital H/W – E-CAD)**.

Οι ασκήσεις καλύπτουν ολόκληρη τη ροή ψηφιακού σχεδιασμού:
από **γραφική σχεδίαση και εξομοίωση TTL κυκλωμάτων**,  
σε **back-end σχεδίαση πλακέτας (PCB)**,  
και τελικά σε **περιγραφή υλικού (VHDL), σύνθεση, χρονική ανάλυση και υλοποίηση σε FPGA**.

---

## 🧪 Δομή & Κατηγοριοποίηση Ασκήσεων

Οι εργαστηριακές ασκήσεις χωρίζονται σε δύο βασικές κατηγορίες:

### 🔹 Α. Σχεδιαστικές Ασκήσεις με Γραφικά Εργαλεία (EA1 – EA4)
- Υλοποίηση σε **OrCAD / OrCAD Express** (περιβάλλον Windows XP)
- Γραφικός σχεδιασμός (schematics)
- Εξομοίωση μέσα από το εργαλείο
- Χρονική ανάλυση και propagation delays
- **Δεν περιλαμβάνουν HDL κώδικα**

### 🔹 Β. Ασκήσεις HDL & Υλοποίησης σε FPGA (EA5 – EA8)
- Περιγραφή σε **VHDL**
- Εξομοίωση με **ModelSim**
- Σύνθεση & Implementation με **Vivado 2019.2 WebPACK**
- Υλοποίηση και επαλήθευση σε **Basys3 (Artix-7)**

---

## 🧪 Αναλυτική Περιγραφή Εργαστηριακών Ασκήσεων

### 🔹 EA1 – Μελέτη καθυστέρησης διάδοσης TTL πυλών
- Γραφική σχεδίαση πύλης AND (7408)
- Αντικατάσταση με υποοικογένειες TTL: 74LS08, 74S08, 74ALS08, 74AS08
- Εξομοίωση στο OrCAD
- Μέτρηση propagation delay (0→1 και 1→0)
- Σύγκριση ταχύτητας μεταξύ TTL οικογενειών

---

### 🔹 EA2 – Top-Down & Bottom-Up σχεδίαση ψηφιακών κυκλωμάτων
- Υλοποίηση πολλαπλασιαστή 2-bit με **Top-Down** προσέγγιση
- Σχεδίαση Full Adder με πύλες TTL
- Υλοποίηση καταχωρητή 2-bit με **Bottom-Up** προσέγγιση
- Χρονική εξομοίωση και επαλήθευση
- Καθαρά γραφικός σχεδιασμός σε OrCAD

---

### 🔹 EA3 – Back-end PCB σχεδίαση (placement & routing)
- Δημιουργία netlist από schematic
- Εισαγωγή στο OrCAD Layout
- Αυτόματο placement ολοκληρωμένων
- Αυτόματο routing σε:
  - πλακέτα δύο επιπέδων (2-layer)
  - πλακέτα ενός επιπέδου (1-layer)
- Ανάλυση περιορισμών routing λόγω τοπολογίας

---

### 🔹 EA4 – Hardware dongle & bidirectional bus
- Υλοποίηση dongle προστασίας λογισμικού (hasp)
- Bidirectional δίαυλος δεδομένων με tri-state buffers
- Μετατροπή δεδομένων σε XS129 (DIN + 129)
- Εξομοίωση tri-state κατάστασης Z
- Πλήρης back-end ροή PCB:
  - επιλογή footprints
  - netlist
  - 2-layer και 4-layer layout με power/ground planes

---

### 🔹 EA5 – Μετρητής 4-bit και 8-bit σε HDL
- Περιγραφή σύγχρονου μετρητή σε **VHDL**
- Παράλληλη φόρτωση, enable και reset
- Σύνθεση 8-bit μετρητή από δύο 4-bit blocks
- Εξομοίωση με **ModelSim**
- Μελέτη κρίσιμης διαδρομής και μέγιστης συχνότητας

---

### 🔹 EA6 – Συνδυαστικά κυκλώματα & 7-segment display
- Υλοποίηση σε VHDL:
  - XOR 4-bit
  - number displayer (0–F)
  - unsigned & signed 2-bit multipliers
- Οδήγηση 7-segment display της Basys3
- Timing analysis μέσω Vivado
- Υπολογισμός fmax από critical paths

---

### 🔹 EA7 – Ρολόι / Χρονόμετρο με χρονισμό
- Υλοποίηση ακολουθιακού συστήματος σε FPGA
- Παραγωγή enable pulses 1Hz και 10Hz από clock 100MHz
- Μέτρηση δευτερολέπτων και δεκάτων
- Multiplexing δύο ψηφίων 7-segment
- Stopwatch λειτουργία (πάγωμα ένδειξης)
- LED thermometer bar για δεκάτα
- Post-implementation timing analysis

---

### 🔹 EA8 – Πρωτόκολλο πληκτρολογίου (PS/2)
- Υλοποίηση πρωτοκόλλου **PS/2 keyboard**
- Ανάγνωση scan codes (make / break)
- Υποστήριξη αριθμών και τελεστών (+, −, ×, ÷)
- Εκτέλεση πράξεων και προβολή αποτελέσματος
- Multiplexed εμφάνιση σε 7-segment display
- Πλήρης ροή:
  HDL → Simulation → Synthesis → Timing → FPGA verification

---

## 🛠️ Εργαλεία & Τεχνολογίες

- **OrCAD / OrCAD Express** (γραφικός σχεδιασμός & simulation)
- **VHDL** (HDL)
- **ModelSim** (λογική εξομοίωση)
- **Vivado 2019.2 WebPACK** (synthesis & implementation)
- **FPGA Board:** Digilent Basys3 (Artix-7, 100MHz)

---

## 📁 Δομή Αποθετηρίου

```text
labs/
├─ EA1/ # TTL gates – propagation delay (OrCAD)
├─ EA2/ # Top-Down / Bottom-Up design
├─ EA3/ # PCB back-end design
├─ EA4/ # Hardware dongle & tri-state bus
├─ EA5/ # 4-bit / 8-bit counter (VHDL)
├─ EA6/ # Combinational logic & 7-seg
├─ EA7/ # Clock, timing & stopwatch
└─ EA8/ # PS/2 keyboard protocol
```

Κάθε φάκελος περιλαμβάνει:
- σχεδιαστικά αρχεία ή VHDL κώδικα,
- αποτελέσματα εξομοίωσης,
- reports χρονισμού / utilization,
- αναφορά άσκησης.

---

## 📜 Άδεια Χρήσης
Το υλικό προορίζεται αποκλειστικά για **εκπαιδευτική χρήση**.
