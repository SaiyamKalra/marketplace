-- CreateEnum
CREATE TYPE "Account" AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED');

-- CreateTable
CREATE TABLE "User" (
    "userId" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "status" "Account" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("userId")
);

-- CreateTable
CREATE TABLE "Youtuber" (
    "channelId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "youtubeChannel" TEXT NOT NULL,
    "channelUrl" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "subscriberCount" INTEGER NOT NULL,
    "profilePic" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Youtuber_pkey" PRIMARY KEY ("channelId")
);

-- CreateTable
CREATE TABLE "YoutuberTeamMember" (
    "memberId" TEXT NOT NULL,
    "channelId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "certification" TEXT NOT NULL,
    "profilePic" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "contract" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "YoutuberTeamMember_pkey" PRIMARY KEY ("memberId")
);

-- CreateTable
CREATE TABLE "Skills" (
    "skillId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Skills_pkey" PRIMARY KEY ("skillId")
);

-- CreateTable
CREATE TABLE "SkillMember" (
    "skillMemberId" TEXT NOT NULL,
    "memberId" TEXT NOT NULL,
    "skillId" TEXT NOT NULL,

    CONSTRAINT "SkillMember_pkey" PRIMARY KEY ("skillMemberId")
);

-- CreateTable
CREATE TABLE "Freelancer" (
    "freelancerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "certification" TEXT NOT NULL,
    "startDate" TIMESTAMP(3) NOT NULL,
    "endDate" TIMESTAMP(3) NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Freelancer_pkey" PRIMARY KEY ("freelancerId")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Youtuber_userId_key" ON "Youtuber"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Youtuber_channelUrl_key" ON "Youtuber"("channelUrl");

-- CreateIndex
CREATE UNIQUE INDEX "YoutuberTeamMember_channelId_key" ON "YoutuberTeamMember"("channelId");

-- CreateIndex
CREATE UNIQUE INDEX "YoutuberTeamMember_userId_key" ON "YoutuberTeamMember"("userId");

-- CreateIndex
CREATE INDEX "YoutuberTeamMember_channelId_userId_idx" ON "YoutuberTeamMember"("channelId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "SkillMember_memberId_key" ON "SkillMember"("memberId");

-- CreateIndex
CREATE UNIQUE INDEX "SkillMember_skillId_key" ON "SkillMember"("skillId");

-- CreateIndex
CREATE INDEX "SkillMember_memberId_skillId_idx" ON "SkillMember"("memberId", "skillId");

-- CreateIndex
CREATE UNIQUE INDEX "Freelancer_userId_key" ON "Freelancer"("userId");

-- AddForeignKey
ALTER TABLE "Youtuber" ADD CONSTRAINT "Youtuber_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YoutuberTeamMember" ADD CONSTRAINT "YoutuberTeamMember_channelId_fkey" FOREIGN KEY ("channelId") REFERENCES "Youtuber"("channelId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "YoutuberTeamMember" ADD CONSTRAINT "YoutuberTeamMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SkillMember" ADD CONSTRAINT "SkillMember_memberId_fkey" FOREIGN KEY ("memberId") REFERENCES "YoutuberTeamMember"("memberId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SkillMember" ADD CONSTRAINT "SkillMember_skillId_fkey" FOREIGN KEY ("skillId") REFERENCES "Skills"("skillId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Freelancer" ADD CONSTRAINT "Freelancer_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE CASCADE ON UPDATE CASCADE;
