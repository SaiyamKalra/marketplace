/*
  Warnings:

  - A unique constraint covering the columns `[memberId,skillId]` on the table `SkillMember` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `Skills` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateEnum
CREATE TYPE "JobStatus" AS ENUM ('OPEN', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ApplicationType" AS ENUM ('FREELANCER', 'YOUTUBER', 'TEAM_MEMBER');

-- CreateEnum
CREATE TYPE "ApplicationStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED');

-- DropIndex
DROP INDEX "SkillMember_memberId_key";

-- DropIndex
DROP INDEX "SkillMember_memberId_skillId_idx";

-- DropIndex
DROP INDEX "SkillMember_skillId_key";

-- DropIndex
DROP INDEX "User_email_idx";

-- DropIndex
DROP INDEX "YoutuberTeamMember_channelId_key";

-- CreateTable
CREATE TABLE "SkillFreelancer" (
    "skillFreelancerId" TEXT NOT NULL,
    "skillId" TEXT NOT NULL,
    "freelancerId" TEXT NOT NULL,

    CONSTRAINT "SkillFreelancer_pkey" PRIMARY KEY ("skillFreelancerId")
);

-- CreateTable
CREATE TABLE "Client" (
    "clientId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "profilePic" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Client_pkey" PRIMARY KEY ("clientId")
);

-- CreateTable
CREATE TABLE "Job" (
    "jobId" TEXT NOT NULL,
    "clientId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "budget" DECIMAL(65,30) NOT NULL,
    "status" "JobStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Job_pkey" PRIMARY KEY ("jobId")
);

-- CreateTable
CREATE TABLE "Application" (
    "applicationId" TEXT NOT NULL,
    "jobId" TEXT NOT NULL,
    "submittedByUserId" TEXT NOT NULL,
    "applicationType" "ApplicationType" NOT NULL,
    "channelId" TEXT,
    "proposal" TEXT NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "status" "ApplicationStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Application_pkey" PRIMARY KEY ("applicationId")
);

-- CreateTable
CREATE TABLE "Payment" (
    "paymentId" TEXT NOT NULL,
    "payerUserId" TEXT NOT NULL,
    "applicationId" TEXT NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "status" "PaymentStatus" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("paymentId")
);

-- CreateIndex
CREATE INDEX "SkillFreelancer_freelancerId_idx" ON "SkillFreelancer"("freelancerId");

-- CreateIndex
CREATE INDEX "SkillFreelancer_skillId_idx" ON "SkillFreelancer"("skillId");

-- CreateIndex
CREATE UNIQUE INDEX "SkillFreelancer_freelancerId_skillId_key" ON "SkillFreelancer"("freelancerId", "skillId");

-- CreateIndex
CREATE UNIQUE INDEX "Client_userId_key" ON "Client"("userId");

-- CreateIndex
CREATE INDEX "Job_clientId_idx" ON "Job"("clientId");

-- CreateIndex
CREATE INDEX "Application_jobId_idx" ON "Application"("jobId");

-- CreateIndex
CREATE INDEX "Application_submittedByUserId_idx" ON "Application"("submittedByUserId");

-- CreateIndex
CREATE INDEX "Application_channelId_idx" ON "Application"("channelId");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_applicationId_key" ON "Payment"("applicationId");

-- CreateIndex
CREATE INDEX "Payment_payerUserId_idx" ON "Payment"("payerUserId");

-- CreateIndex
CREATE INDEX "SkillMember_memberId_idx" ON "SkillMember"("memberId");

-- CreateIndex
CREATE INDEX "SkillMember_skillId_idx" ON "SkillMember"("skillId");

-- CreateIndex
CREATE UNIQUE INDEX "SkillMember_memberId_skillId_key" ON "SkillMember"("memberId", "skillId");

-- CreateIndex
CREATE UNIQUE INDEX "Skills_name_key" ON "Skills"("name");

-- AddForeignKey
ALTER TABLE "SkillFreelancer" ADD CONSTRAINT "SkillFreelancer_skillId_fkey" FOREIGN KEY ("skillId") REFERENCES "Skills"("skillId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SkillFreelancer" ADD CONSTRAINT "SkillFreelancer_freelancerId_fkey" FOREIGN KEY ("freelancerId") REFERENCES "Freelancer"("freelancerId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Client" ADD CONSTRAINT "Client_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("userId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Job" ADD CONSTRAINT "Job_clientId_fkey" FOREIGN KEY ("clientId") REFERENCES "Client"("clientId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES "Job"("jobId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_submittedByUserId_fkey" FOREIGN KEY ("submittedByUserId") REFERENCES "User"("userId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Application" ADD CONSTRAINT "Application_channelId_fkey" FOREIGN KEY ("channelId") REFERENCES "Youtuber"("channelId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_payerUserId_fkey" FOREIGN KEY ("payerUserId") REFERENCES "User"("userId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_applicationId_fkey" FOREIGN KEY ("applicationId") REFERENCES "Application"("applicationId") ON DELETE CASCADE ON UPDATE CASCADE;
