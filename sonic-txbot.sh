#!/bin/bash

BOLD_BLUE='\033[1;34m'
NC='\033[0m'
echo

# 설치할 Node.js 버전 설정 (예: 18.x LTS)
NODE_VERSION="18.x"

if ! command -v node &> /dev/null
then
    echo -e "${BOLD_BLUE}Node.js가 설치되지 않았습니다. Node.js ${NODE_VERSION}를 설치합니다...${NC}"
    echo
    curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo -e "${BOLD_BLUE}Node.js가 이미 설치되어 있습니다.${NC}"
fi
echo
if ! command -v npm &> /dev/null
then
    echo -e "${BOLD_BLUE}npm이 설치되지 않았습니다. npm을 설치합니다...${NC}"
    echo
    sudo apt-get install -y npm
else
    echo -e "${BOLD_BLUE}npm이 이미 설치되어 있습니다.${NC}"
fi
echo
echo -e "${BOLD_BLUE}프로젝트 디렉토리를 생성하고 해당 디렉토리로 이동합니다.${NC}"
mkdir -p SonicBatchTx
cd SonicBatchTx
echo
echo -e "${BOLD_BLUE}새로운 Node.js 프로젝트를 초기화합니다.${NC}"
echo
npm init -y
echo
echo -e "${BOLD_BLUE}필요한 패키지를 설치합니다.${NC}"
echo
npm install @solana/web3.js chalk bs58
echo
echo -e "${BOLD_BLUE}개인 키를 입력받습니다.${NC}"
echo
read -p "당신의 Solana 지갑 개인 키를 입력하세요: " privkey
echo
echo -e "${BOLD_BLUE}Node.js 스크립트 파일을 생성합니다.${NC}"
echo
cat << EOF > zun.mjs
import web3 from "@solana/web3.js";
import chalk from "chalk";
import bs58 from "bs58";

const connection = new web3.Connection("https://devnet.sonic.game", 'confirmed');

const privkey = "$privkey";
const from = web3.Keypair.fromSecretKey(bs58.decode(privkey));
const to = web3.Keypair.generate();

(async () => {
    const transaction = new web3.Transaction().add(
        web3.SystemProgram.transfer({
          fromPubkey: from.publicKey,
          toPubkey: to.publicKey,
          lamports: web3.LAMPORTS_PER_SOL * 0.001,
        }),
      );
    
    
     const txCount = 100;
     for (let i = 0; i < txCount; i++) {
     const signature = await web3.sendAndConfirmTransaction(
       connection,
       transaction,
       [from],
     );
   console.log(chalk.blue('Tx hash :'), signature);
   console.log("");
   const randomDelay = Math.floor(Math.random() * 3) + 1;
   await new Promise(resolve => setTimeout(resolve, randomDelay * 1000));
 }
})();
EOF
echo
echo -e "${BOLD_BLUE}Node.js 스크립트를 실행합니다.${NC}"
echo

echo -e "${YELLOW}모든 작업이 완료되었습니다. 컨트롤+A+D로 스크린을 종료해주세요.${NC}"
echo -e "${GREEN}스크립트 작성자: https://t.me/kjkresearch${NC}"

