# GSSSB CCE મુખ્ય પરીક્ષા (ગ્રુપ B) ૨૦૦ ગુણ રિવિઝન પોર્ટલ
### (GSSSB CCE Group B Mains Revision App & Web Portal)

આ પોર્ટલ GSSSB CCE મુખ્ય પરીક્ષા (ગ્રુપ B) ના ૨૦૦ ગુણના સંપૂર્ણ અભ્યાસક્રમ માટે તૈયાર કરવામાં આવ્યું છે. જેમાં ડૉ. દિનેશ ગેહલોત (ઉત્કર્ષ ક્લાસીસ) ના તમામ વિડિયો વ્યાખ્યાનોના આધારે વિગતવાર ગુજરાતી રિવિઝન નોટ્સ, માઇક્રો-સિલેબસ અને પરીક્ષાલક્ષી MCQs સામેલ છે.

---

## 🌐 લાઈવ વેબ પોર્ટલ (GitHub Pages)
જ્યારે પણ આ રીપોઝીટરીમાં કોડ પુશ કરવામાં આવશે, ત્યારે GitHub Actions ઓટોમેટીક Flutter Web બિલ્ડ કરીને GitHub Pages પર લાઈવ સાઈટ અપડેટ કરી દેશે.

---

## 📚 વિષયવાર રિવિઝન નોટ્સ (Gujarati Revision Notes)

### ■ વિભાગ ૧: ભારતીય રાજ્યવ્યવસ્થા અને બંધારણ (૨૦ ગુણ)
1. **બંધારણ સભા અને ઐતિહાસિક પૃષ્ઠભૂમિ (Constituent Assembly):**  
   📖 [CONSTITUENT_ASSEMBLY_NOTES_GUJARATI.md](./CONSTITUENT_ASSEMBLY_NOTES_GUJARATI.md)  
   *(ઐતિહાસિક માંગ, કેબિનેટ મિશન, સભ્ય સંખ્યા, સમિતિઓ, પ્રથમ બેઠક, સ્વીકૃતિ અને અમલીકરણ)*

2. **ભારતીય બંધારણનું આમુખ (Preamble of the Constitution):**  
   📖 [PREAMBLE_NOTES_GUJARATI.md](./PREAMBLE_NOTES_GUJARATI.md)  
   *(ઉદ્દેશ્ય પ્રસ્તાવ, મુખ્ય શબ્દો, ૪૨મો સુધારો ૧૯૭૬, બેરુબારી અને કેશવાનંદ ભારતી કેસ)*

3. **સંઘ અને તેનું રાજ્યક્ષેત્ર (The Union & Its Territory: ભાગ-૧, કલમ ૧ થી ૪):**  
   📖 [UNION_AND_TERRITORY_NOTES_GUJARATI.md](./UNION_AND_TERRITORY_NOTES_GUJARATI.md)  
   *(કલમ ૧ થી ૪, ધર આયોગ, JVP સમિતિ, ફઝલ અલી પંચ, ૭મો સુધારો ૧૯૫૬, નવા રાજ્યોની રચના)*

4. **મૂળભૂત અધિકારો - ભાગ ૧: સમાનતાનો અધિકાર (Fundamental Rights: ભાગ-૩, કલમ ૧૨ થી ૧૮):**  
   📖 [FUNDAMENTAL_RIGHTS_EQUALITY_NOTES_GUJARATI.md](./FUNDAMENTAL_RIGHTS_EQUALITY_NOTES_GUJARATI.md)  
   *(કલમ ૧૨-૧૮, કાયદા સમક્ષ સમાનતા, ભેદભાવ નિષેધ, EWS ૧૦૩મો સુધારો, ઈન્દ્રા સાહની કેસ, અસ્પૃશ્યતા નિવારણ, ખિતાબોની નાબૂદી)*

5. **મૂળભૂત અધિકારો - ભાગ ૨: સ્વતંત્રતાનો અધિકાર (Fundamental Rights: ભાગ-૩, કલમ ૧૯ થી ૨૨):**  
   📖 [FUNDAMENTAL_RIGHTS_FREEDOM_NOTES_GUJARATI.md](./FUNDAMENTAL_RIGHTS_FREEDOM_NOTES_GUJARATI.md)  
   *(કલમ ૧૯-૨૨, ૬ સ્વતંત્રતાઓ, વાજબી નિયંત્રણો, પ્રેસ/RTI/ધ્વજ કેસ, કલમ ૨૦ દોષસિદ્ધિ રક્ષણ, કલમ ૨૧ જીવનનો હક & મેનકા ગાંધી કેસ, પુટ્ટાસ્વામી પ્રાઈવસી કેસ, કલમ ૨૧-A RTE, કલમ ૨૨ અટકાયત)*


---

## 🚀 GitHub પર પુશ કરવા અને Web લાઈવ કરવાની રીત (How to Push & Go Live)

### પગલું ૧: ગીટ કમિટ કરો (Commit code)
```bash
git add .
git commit -m "Update CCE revision notes and web app"
```

### પગલું ૨: GitHub પર રીપોઝીટરી બનાવી લિંક કરો (Set remote)
```bash
# તમારી રીપોઝીટરી URL મુજબ:
git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPO_NAME>.git
git branch -M main
git push -u origin main
```

### પગલું ૩: GitHub Pages ઓન કરો (Enable GitHub Pages)
1. GitHub રીપોઝીટરીના **Settings** > **Pages** પર જાઓ.
2. **Build and deployment > Source** માં:
   - **Deploy from a branch** પસંદ કરો -> Branch: `gh-pages` -> Folder: `/(root)` -> **Save**.
   *(GitHub Action આપોઆપ `gh-pages` બ્રાન્ચ બનાવી બિલ્ડ અપલોડ કરી દેશે).*
3. તમારી વેબસાઈટ નીચેની લિંક પર લાઈવ થઈ જશે:
   `https://<YOUR_USERNAME>.github.io/<YOUR_REPO_NAME>/`

---

## 💻 લોકલ કમ્પ્યુટર પર વેબ ચલાવવા માટે (Run Locally on Web)
```bash
flutter run -d chrome
```
અથવા
```bash
flutter build web --release
```
