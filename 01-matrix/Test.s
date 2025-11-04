	.file	"Test.c"
	.text
	.p2align 4
	.type	routine_81, @function
routine_81:
.LFB74:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	8(%rdi), %rsi
	movq	16(%rdi), %rcx
	movl	12(%rsi), %r8d
	movl	16(%rcx), %eax
	movl	%r8d, %edx
	shrl	$31, %edx
	movl	24(%rdi), %r9d
	addl	%r8d, %edx
	movl	%eax, 8(%rsp)
	movl	16(%rsi), %eax
	sarl	%edx
	imull	%edx, %r9d
	movq	%rdi, 72(%rsp)
	testl	%r8d, %r8d
	movl	%eax, 12(%rsp)
	movl	28(%rdi), %r10d
	movl	32(%rdi), %eax
	leal	3(%r8), %edi
	cmovns	%r8d, %edi
	leal	(%rdx,%r9), %ebx
	sarl	$2, %edi
	movl	%ebx, 36(%rsp)
	leal	(%r9,%rdi), %r13d
	cmpl	%edi, %edx
	jle	.L5
	movl	8(%rsp), %r11d
	movl	12(%rsp), %r14d
	movl	%r11d, %ebx
	shrl	$31, %ebx
	movl	%r14d, %edx
	addl	%r11d, %ebx
	shrl	$31, %edx
	sarl	%ebx
	addl	%r14d, %edx
	imull	%ebx, %r10d
	sarl	%edx
	imull	%edx, %eax
	addl	%r10d, %ebx
	movl	%r10d, 32(%rsp)
	addl	%eax, %edx
	cmpl	%ebx, %r10d
	jge	.L5
	cmpl	%edx, %eax
	jge	.L5
	movq	(%rcx), %rbp
	movl	%r11d, %ecx
	imull	%eax, %ecx
	movl	%r11d, %edi
	imull	%r13d, %edi
	movslq	%ecx, %rcx
	salq	$4, %rcx
	movq	(%rsi), %rsi
	movq	%rcx, 24(%rsp)
	movl	%edi, %r15d
	movslq	%r10d, %rcx
	movq	72(%rsp), %rdi
	decl	%edx
	movq	%rcx, 56(%rsp)
	subl	%eax, %edx
	movslq	%eax, %rcx
	movq	(%rdi), %rdi
	movq	%rsi, 16(%rsp)
	addq	%rcx, %rdx
	addq	$16, %rsi
	imull	%r13d, %r14d
	movq	%rcx, 48(%rsp)
	movq	%rsi, 64(%rsp)
	movq	%rdx, 40(%rsp)
	movq	(%rdi), %r12
	movslq	%r11d, %rdi
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L7:
	movq	56(%rsp), %rax
	movq	48(%rsp), %rcx
	movslq	%r15d, %rdx
	leaq	(%rax,%rdx), %r8
	movslq	%r14d, %rax
	leaq	(%rcx,%rax), %r10
	movq	24(%rsp), %r11
	movq	64(%rsp), %rcx
	addq	40(%rsp), %rax
	salq	$4, %r10
	salq	$4, %rdx
	salq	$4, %rax
	movl	32(%rsp), %r9d
	salq	$4, %r8
	addq	16(%rsp), %r10
	subq	%rdx, %r11
	leaq	(%rcx,%rax), %rsi
	.p2align 4,,10
	.p2align 3
.L4:
	leaq	(%r12,%r8), %rcx
	fldt	(%rcx)
	leaq	(%r11,%r8), %rdx
	addq	%rbp, %rdx
	movq	%r10, %rax
	.p2align 4,,10
	.p2align 3
.L6:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rdi, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fld	%st(0)
	fstpt	(%rcx)
	cmpq	%rax, %rsi
	jne	.L6
	fstp	%st(0)
	incl	%r9d
	addq	$16, %r8
	cmpl	%ebx, %r9d
	jne	.L4
	incl	%r13d
	addl	8(%rsp), %r15d
	addl	12(%rsp), %r14d
	cmpl	36(%rsp), %r13d
	jne	.L7
.L5:
	movq	72(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE74:
	.size	routine_81, .-routine_81
	.p2align 4
	.type	routine_80, @function
routine_80:
.LFB73:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$88, %rsp
	.cfi_def_cfa_offset 144
	movq	8(%rdi), %rsi
	movq	%rdi, 72(%rsp)
	movl	12(%rsi), %edi
	movq	16(%rbx), %rcx
	movl	%edi, %r13d
	shrl	$31, %r13d
	addl	%edi, %r13d
	sarl	%r13d
	imull	24(%rbx), %r13d
	movl	16(%rcx), %eax
	testl	%edi, %edi
	leal	3(%rdi), %edx
	cmovns	%edi, %edx
	movl	%eax, 8(%rsp)
	movl	16(%rsi), %eax
	sarl	$2, %edx
	movl	%eax, 12(%rsp)
	movl	28(%rbx), %r8d
	movl	32(%rbx), %eax
	leal	(%rdx,%r13), %ebx
	movl	%ebx, 36(%rsp)
	cmpl	%ebx, %r13d
	jge	.L19
	movl	8(%rsp), %r11d
	movl	12(%rsp), %r14d
	movl	%r11d, %ebx
	shrl	$31, %ebx
	movl	%r14d, %edx
	addl	%r11d, %ebx
	shrl	$31, %edx
	sarl	%ebx
	movl	%r8d, %r10d
	addl	%r14d, %edx
	imull	%ebx, %r10d
	sarl	%edx
	imull	%edx, %eax
	addl	%r10d, %ebx
	movl	%r10d, 32(%rsp)
	addl	%eax, %edx
	cmpl	%ebx, %r10d
	jge	.L19
	cmpl	%edx, %eax
	jge	.L19
	movq	(%rcx), %rbp
	movl	%r11d, %ecx
	imull	%eax, %ecx
	movl	%r11d, %edi
	imull	%r13d, %edi
	movslq	%ecx, %rcx
	salq	$4, %rcx
	movq	(%rsi), %rsi
	movq	%rcx, 24(%rsp)
	movl	%edi, %r15d
	movslq	%r10d, %rcx
	movq	72(%rsp), %rdi
	decl	%edx
	movq	%rcx, 64(%rsp)
	subl	%eax, %edx
	movslq	%eax, %rcx
	movq	(%rdi), %rdi
	movq	%rsi, 16(%rsp)
	addq	%rcx, %rdx
	addq	$16, %rsi
	imull	%r13d, %r14d
	movq	%rcx, 48(%rsp)
	movq	%rsi, 56(%rsp)
	movq	%rdx, 40(%rsp)
	movq	(%rdi), %r12
	movslq	%r11d, %rdi
	salq	$4, %rdi
	.p2align 4,,10
	.p2align 3
.L21:
	movq	64(%rsp), %rax
	movq	48(%rsp), %rcx
	movslq	%r15d, %rdx
	leaq	(%rax,%rdx), %r8
	movslq	%r14d, %rax
	leaq	(%rcx,%rax), %r10
	movq	24(%rsp), %r11
	movq	56(%rsp), %rcx
	addq	40(%rsp), %rax
	salq	$4, %r10
	salq	$4, %rdx
	salq	$4, %rax
	movl	32(%rsp), %r9d
	salq	$4, %r8
	addq	16(%rsp), %r10
	subq	%rdx, %r11
	leaq	(%rcx,%rax), %rsi
	.p2align 4,,10
	.p2align 3
.L18:
	leaq	(%r12,%r8), %rcx
	fldt	(%rcx)
	leaq	(%r11,%r8), %rdx
	addq	%rbp, %rdx
	movq	%r10, %rax
	.p2align 4,,10
	.p2align 3
.L20:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rdi, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	fld	%st(0)
	fstpt	(%rcx)
	cmpq	%rax, %rsi
	jne	.L20
	fstp	%st(0)
	incl	%r9d
	addq	$16, %r8
	cmpl	%ebx, %r9d
	jne	.L18
	incl	%r13d
	addl	8(%rsp), %r15d
	addl	12(%rsp), %r14d
	cmpl	36(%rsp), %r13d
	jne	.L21
.L19:
	movq	72(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.cfi_endproc
.LFE73:
	.size	routine_80, .-routine_80
	.p2align 4
	.type	routine_41, @function
routine_41:
.LFB62:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	8(%rdi), %r10
	movq	%rdi, 24(%rsp)
	movl	12(%r10), %eax
	movl	%eax, %ebx
	shrl	$31, %ebx
	addl	%eax, %ebx
	sarl	%ebx
	movl	%eax, 12(%rsp)
	cmpl	%ebx, %eax
	jle	.L29
	movq	16(%rdi), %r13
	movl	16(%r13), %ebp
	testl	%ebp, %ebp
	jle	.L29
	movq	(%rdi), %rax
	movl	%ebx, %r15d
	movq	(%rax), %rax
	movl	12(%r13), %r12d
	imull	%ebp, %r15d
	movq	%rax, 16(%rsp)
	movslq	%ebp, %rcx
	salq	$4, %rcx
	fldz
	leal	-1(%r12), %r14d
	.p2align 4,,10
	.p2align 3
.L31:
	movslq	%r15d, %r11
	salq	$4, %r11
	addq	16(%rsp), %r11
	xorl	%edi, %edi
	xorl	%r8d, %r8d
	.p2align 4,,10
	.p2align 3
.L36:
	testl	%r12d, %r12d
	jle	.L40
	movl	16(%r10), %esi
	movq	(%r10), %r9
	imull	%ebx, %esi
	movq	0(%r13), %rdx
	fld	%st(0)
	movslq	%esi, %rsi
	movq	%rsi, %rax
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r9, %rax
	addq	%rdi, %rdx
	leaq	16(%r9,%rsi), %rsi
	.p2align 4,,10
	.p2align 3
.L32:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L32
	incl	%r8d
	fstpt	(%r11,%rdi)
	addq	$16, %rdi
	cmpl	%ebp, %r8d
	jne	.L36
.L33:
	incl	%ebx
	addl	%ebp, %r15d
	cmpl	%ebx, 12(%rsp)
	jne	.L31
	fstp	%st(0)
.L29:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L40:
	fld	%st(0)
	incl	%r8d
	fstpt	(%r11,%rdi)
	addq	$16, %rdi
	cmpl	%ebp, %r8d
	jne	.L36
	jmp	.L33
	.cfi_endproc
.LFE62:
	.size	routine_41, .-routine_41
	.p2align 4
	.type	routine_40, @function
routine_40:
.LFB61:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	8(%rdi), %r10
	movq	%rdi, 24(%rsp)
	movl	12(%r10), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%eax, %edx
	sarl	%edx
	movl	%edx, 20(%rsp)
	cmpl	$1, %eax
	jle	.L42
	movq	16(%rdi), %r13
	movl	16(%r13), %ebp
	testl	%ebp, %ebp
	jle	.L42
	movq	(%rdi), %rax
	movl	12(%r13), %r12d
	movq	(%rax), %rax
	movslq	%ebp, %rcx
	movq	%rax, 8(%rsp)
	salq	$4, %rcx
	xorl	%r15d, %r15d
	xorl	%ebx, %ebx
	fldz
	leal	-1(%r12), %r14d
	.p2align 4,,10
	.p2align 3
.L44:
	movslq	%r15d, %r11
	salq	$4, %r11
	addq	8(%rsp), %r11
	xorl	%edi, %edi
	xorl	%r8d, %r8d
	.p2align 4,,10
	.p2align 3
.L49:
	testl	%r12d, %r12d
	jle	.L53
	movl	16(%r10), %esi
	movq	(%r10), %r9
	imull	%ebx, %esi
	movq	0(%r13), %rdx
	fld	%st(0)
	movslq	%esi, %rsi
	movq	%rsi, %rax
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r9, %rax
	addq	%rdi, %rdx
	leaq	16(%r9,%rsi), %rsi
	.p2align 4,,10
	.p2align 3
.L45:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L45
	incl	%r8d
	fstpt	(%r11,%rdi)
	addq	$16, %rdi
	cmpl	%ebp, %r8d
	jne	.L49
.L46:
	incl	%ebx
	addl	%ebp, %r15d
	cmpl	20(%rsp), %ebx
	jl	.L44
	fstp	%st(0)
.L42:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L53:
	fld	%st(0)
	incl	%r8d
	fstpt	(%r11,%rdi)
	addq	$16, %rdi
	cmpl	%ebp, %r8d
	jne	.L49
	jmp	.L46
	.cfi_endproc
.LFE61:
	.size	routine_40, .-routine_40
	.p2align 4
	.type	routine_51, @function
routine_51:
.LFB65:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rdi), %r13
	movq	%rdi, 24(%rsp)
	movl	16(%r13), %edi
	movl	%edi, %eax
	movl	%edi, 12(%rsp)
	shrl	$31, %edi
	movl	%edi, %r15d
	addl	%eax, %r15d
	sarl	%r15d
	cmpl	%r15d, %eax
	jle	.L55
	movq	8(%rbx), %r12
	movl	%eax, %edi
	movl	12(%r12), %ebp
	movq	%rbx, %rax
	testl	%ebp, %ebp
	jle	.L55
	movq	(%rax), %rax
	movl	16(%r12), %r11d
	movq	(%rax), %rax
	movslq	%r15d, %rbx
	movq	%rax, 16(%rsp)
	movslq	%edi, %rcx
	salq	$4, %rbx
	salq	$4, %rcx
	fldz
	leal	-1(%r11), %r14d
	.p2align 4,,10
	.p2align 3
.L57:
	movq	16(%rsp), %rax
	xorl	%r9d, %r9d
	leaq	(%rax,%rbx), %r8
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L62:
	testl	%r11d, %r11d
	jle	.L66
	movslq	%r9d, %rsi
	movq	(%r12), %r10
	movq	%rsi, %rax
	movq	0(%r13), %rdx
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r10, %rax
	addq	%rbx, %rdx
	leaq	16(%r10,%rsi), %rsi
	fld	%st(0)
	.p2align 4,,10
	.p2align 3
.L58:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L58
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L62
.L59:
	incl	%r15d
	addq	$16, %rbx
	cmpl	%r15d, 12(%rsp)
	jne	.L57
	fstp	%st(0)
.L55:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L66:
	fld	%st(0)
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L62
	jmp	.L59
	.cfi_endproc
.LFE65:
	.size	routine_51, .-routine_51
	.p2align 4
	.type	routine_50, @function
routine_50:
.LFB64:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rdi), %r13
	movq	%rdi, 24(%rsp)
	movslq	16(%r13), %rax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%eax, %edx
	sarl	%edx
	movl	%edx, 20(%rsp)
	cmpl	$1, %eax
	jle	.L68
	movq	8(%rdi), %r12
	movl	12(%r12), %ebp
	testl	%ebp, %ebp
	jle	.L68
	movq	(%rdi), %rdx
	movl	16(%r12), %r11d
	movq	(%rdx), %rbx
	salq	$4, %rax
	movq	%rbx, 8(%rsp)
	movq	%rax, %rcx
	xorl	%ebx, %ebx
	xorl	%r15d, %r15d
	fldz
	leal	-1(%r11), %r14d
	.p2align 4,,10
	.p2align 3
.L70:
	movq	8(%rsp), %rax
	xorl	%r9d, %r9d
	leaq	(%rax,%rbx), %r8
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L75:
	testl	%r11d, %r11d
	jle	.L79
	movslq	%r9d, %rsi
	movq	(%r12), %r10
	movq	%rsi, %rax
	movq	0(%r13), %rdx
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r10, %rax
	addq	%rbx, %rdx
	leaq	16(%r10,%rsi), %rsi
	fld	%st(0)
	.p2align 4,,10
	.p2align 3
.L71:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L71
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L75
.L72:
	incl	%r15d
	addq	$16, %rbx
	cmpl	20(%rsp), %r15d
	jl	.L70
	fstp	%st(0)
.L68:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L79:
	fld	%st(0)
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L75
	jmp	.L72
	.cfi_endproc
.LFE64:
	.size	routine_50, .-routine_50
	.p2align 4
	.type	routine_63, @function
routine_63:
.LFB70:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rdi), %r13
	movq	%rdi, 24(%rsp)
	movl	16(%r13), %edi
	leal	(%rdi,%rdi,2), %eax
	testl	%eax, %eax
	leal	3(%rax), %r15d
	cmovns	%eax, %r15d
	movl	%edi, 12(%rsp)
	sarl	$2, %r15d
	cmpl	%r15d, %edi
	jle	.L81
	movq	8(%rbx), %r12
	movq	%rbx, %rax
	movl	12(%r12), %ebp
	testl	%ebp, %ebp
	jle	.L81
	movq	(%rax), %rax
	movl	16(%r12), %r11d
	movq	(%rax), %rax
	movslq	%r15d, %rbx
	movq	%rax, 16(%rsp)
	movslq	%edi, %rcx
	salq	$4, %rbx
	salq	$4, %rcx
	fldz
	leal	-1(%r11), %r14d
	.p2align 4,,10
	.p2align 3
.L83:
	movq	16(%rsp), %rax
	xorl	%r9d, %r9d
	leaq	(%rax,%rbx), %r8
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L88:
	testl	%r11d, %r11d
	jle	.L92
	movslq	%r9d, %rsi
	movq	(%r12), %r10
	movq	%rsi, %rax
	movq	0(%r13), %rdx
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r10, %rax
	addq	%rbx, %rdx
	leaq	16(%r10,%rsi), %rsi
	fld	%st(0)
	.p2align 4,,10
	.p2align 3
.L84:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L84
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L88
.L85:
	incl	%r15d
	addq	$16, %rbx
	cmpl	%r15d, 12(%rsp)
	jne	.L83
	fstp	%st(0)
.L81:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L92:
	fld	%st(0)
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L88
	jmp	.L85
	.cfi_endproc
.LFE70:
	.size	routine_63, .-routine_63
	.p2align 4
	.type	routine_62, @function
routine_62:
.LFB69:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rdi), %r13
	movq	%rdi, 24(%rsp)
	movslq	16(%r13), %rax
	movl	%eax, %r15d
	shrl	$31, %r15d
	leal	(%rax,%rax,2), %ecx
	addl	%eax, %r15d
	sarl	%r15d
	leal	3(%rcx), %edx
	testl	%ecx, %ecx
	cmovns	%ecx, %edx
	sarl	$2, %edx
	movl	%edx, 20(%rsp)
	cmpl	%edx, %r15d
	jge	.L94
	movq	8(%rdi), %r12
	movl	12(%r12), %ebp
	testl	%ebp, %ebp
	jle	.L94
	movq	(%rdi), %rdx
	movl	16(%r12), %r11d
	movq	(%rdx), %rdi
	movslq	%r15d, %rbx
	movq	%rdi, 8(%rsp)
	salq	$4, %rax
	salq	$4, %rbx
	movq	%rax, %rcx
	fldz
	leal	-1(%r11), %r14d
	.p2align 4,,10
	.p2align 3
.L96:
	movq	8(%rsp), %rax
	xorl	%r9d, %r9d
	leaq	(%rax,%rbx), %r8
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L101:
	testl	%r11d, %r11d
	jle	.L105
	movslq	%r9d, %rsi
	movq	(%r12), %r10
	movq	%rsi, %rax
	movq	0(%r13), %rdx
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r10, %rax
	addq	%rbx, %rdx
	leaq	16(%r10,%rsi), %rsi
	fld	%st(0)
	.p2align 4,,10
	.p2align 3
.L97:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L97
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L101
.L98:
	incl	%r15d
	addq	$16, %rbx
	cmpl	20(%rsp), %r15d
	jne	.L96
	fstp	%st(0)
.L94:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L105:
	fld	%st(0)
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L101
	jmp	.L98
	.cfi_endproc
.LFE69:
	.size	routine_62, .-routine_62
	.p2align 4
	.type	routine_61, @function
routine_61:
.LFB68:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rdi), %r13
	movq	%rdi, 24(%rsp)
	movslq	16(%r13), %rax
	testl	%eax, %eax
	leal	3(%rax), %r15d
	movl	%eax, %edx
	cmovns	%eax, %r15d
	shrl	$31, %edx
	addl	%eax, %edx
	sarl	%edx
	sarl	$2, %r15d
	movl	%edx, 20(%rsp)
	cmpl	%edx, %r15d
	jge	.L107
	movq	8(%rdi), %r12
	movl	12(%r12), %ebp
	testl	%ebp, %ebp
	jle	.L107
	movq	(%rdi), %rdx
	movl	16(%r12), %r11d
	movq	(%rdx), %rdi
	movslq	%r15d, %rbx
	movq	%rdi, 8(%rsp)
	salq	$4, %rax
	salq	$4, %rbx
	movq	%rax, %rcx
	fldz
	leal	-1(%r11), %r14d
	.p2align 4,,10
	.p2align 3
.L109:
	movq	8(%rsp), %rax
	xorl	%r9d, %r9d
	leaq	(%rax,%rbx), %r8
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L114:
	testl	%r11d, %r11d
	jle	.L118
	movslq	%r9d, %rsi
	movq	(%r12), %r10
	movq	%rsi, %rax
	movq	0(%r13), %rdx
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r10, %rax
	addq	%rbx, %rdx
	leaq	16(%r10,%rsi), %rsi
	fld	%st(0)
	.p2align 4,,10
	.p2align 3
.L110:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L110
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L114
.L111:
	incl	%r15d
	addq	$16, %rbx
	cmpl	20(%rsp), %r15d
	jne	.L109
	fstp	%st(0)
.L107:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L118:
	fld	%st(0)
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L114
	jmp	.L111
	.cfi_endproc
.LFE68:
	.size	routine_61, .-routine_61
	.p2align 4
	.type	routine_60, @function
routine_60:
.LFB67:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	movq	16(%rdi), %r13
	movq	%rdi, 24(%rsp)
	movslq	16(%r13), %rax
	testl	%eax, %eax
	leal	3(%rax), %edx
	cmovns	%eax, %edx
	sarl	$2, %edx
	movl	%edx, 20(%rsp)
	cmpl	$3, %eax
	jle	.L120
	movq	8(%rdi), %r12
	movl	12(%r12), %ebp
	testl	%ebp, %ebp
	jle	.L120
	movq	(%rdi), %rdx
	movl	16(%r12), %r11d
	movq	(%rdx), %rbx
	salq	$4, %rax
	movq	%rbx, 8(%rsp)
	movq	%rax, %rcx
	xorl	%ebx, %ebx
	xorl	%r15d, %r15d
	fldz
	leal	-1(%r11), %r14d
	.p2align 4,,10
	.p2align 3
.L122:
	movq	8(%rsp), %rax
	xorl	%r9d, %r9d
	leaq	(%rax,%rbx), %r8
	xorl	%edi, %edi
	.p2align 4,,10
	.p2align 3
.L127:
	testl	%r11d, %r11d
	jle	.L131
	movslq	%r9d, %rsi
	movq	(%r12), %r10
	movq	%rsi, %rax
	movq	0(%r13), %rdx
	addq	%r14, %rsi
	salq	$4, %rax
	salq	$4, %rsi
	addq	%r10, %rax
	addq	%rbx, %rdx
	leaq	16(%r10,%rsi), %rsi
	fld	%st(0)
	.p2align 4,,10
	.p2align 3
.L123:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rsi
	jne	.L123
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L127
.L124:
	incl	%r15d
	addq	$16, %rbx
	cmpl	20(%rsp), %r15d
	jl	.L122
	fstp	%st(0)
.L120:
	movq	24(%rsp), %rdi
	call	free@PLT
	xorl	%edi, %edi
	call	pthread_exit@PLT
	.p2align 4,,10
	.p2align 3
.L131:
	fld	%st(0)
	incl	%edi
	fstpt	(%r8)
	addl	%r11d, %r9d
	addq	%rcx, %r8
	cmpl	%ebp, %edi
	jne	.L127
	jmp	.L124
	.cfi_endproc
.LFE67:
	.size	routine_60, .-routine_60
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC2:
	.string	"Error: row or col sizes cannot be below 0\n"
	.text
	.p2align 4
	.type	init_matrix.part.0, @function
init_matrix.part.0:
.LFB83:
	.cfi_startproc
	pushq	%rax
	.cfi_def_cfa_offset 16
	popq	%rax
	.cfi_def_cfa_offset 8
	leaq	.LC2(%rip), %rdi
	movl	$42, %edx
	movl	$1, %esi
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rcx
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE83:
	.size	init_matrix.part.0, .-init_matrix.part.0
	.set	init_matrix_r.part.0,init_matrix.part.0
	.p2align 4
	.globl	randfrom
	.type	randfrom, @function
randfrom:
.LFB52:
	.cfi_startproc
	endbr64
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	fldt	64(%rsp)
	fldt	48(%rsp)
	fsubrp	%st, %st(1)
	fstpt	16(%rsp)
	call	rand@PLT
	movl	%eax, 12(%rsp)
	fildl	12(%rsp)
	fldt	.LC3(%rip)
	fldt	16(%rsp)
	fmulp	%st, %st(1)
	fmulp	%st, %st(1)
	fldt	48(%rsp)
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	faddp	%st, %st(1)
	ret
	.cfi_endproc
.LFE52:
	.size	randfrom, .-randfrom
	.p2align 4
	.globl	bijk
	.type	bijk, @function
bijk:
.LFB76:
	.cfi_startproc
	endbr64
	movl	%ecx, %eax
	movq	%rdx, %r11
	cltd
	idivl	%r8d
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rdi, -16(%rsp)
	movl	%r8d, -20(%rsp)
	movl	%ecx, -36(%rsp)
	imull	%r8d, %eax
	movl	%eax, -24(%rsp)
	testl	%eax, %eax
	jle	.L151
	testl	%ecx, %ecx
	jle	.L151
	movslq	%r8d, %rax
	movq	%rax, -32(%rsp)
	movq	%rsi, %r10
	xorl	%r15d, %r15d
	xorl	%r14d, %r14d
	movl	%r8d, %r12d
.L139:
	leal	-1(%r12), %ebp
	movq	$0, -56(%rsp)
	subl	%r14d, %ebp
	xorl	%r13d, %r13d
	addq	%r15, %rbp
.L146:
	movl	%r13d, %eax
	addl	-20(%rsp), %r13d
	cmpl	%r13d, %eax
	jge	.L143
	movq	-16(%rsp), %rax
	movq	(%rax), %rbx
	movl	16(%rax), %eax
	movq	%rbx, -48(%rsp)
	movl	%eax, -40(%rsp)
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L145:
	movl	-40(%rsp), %edi
	movq	-56(%rsp), %r8
	imull	%ebx, %edi
	movslq	%edi, %rdi
	addq	%r8, %rdi
	salq	$4, %rdi
	addq	-48(%rsp), %rdi
	.p2align 4,,10
	.p2align 3
.L142:
	fldt	(%rdi)
	cmpl	%r14d, %r12d
	jle	.L140
	movslq	16(%r11), %rcx
	movl	16(%r10), %esi
	movq	%rcx, %rdx
	imull	%ebx, %esi
	imull	%r14d, %edx
	movq	(%r10), %r9
	movslq	%esi, %rsi
	movslq	%edx, %rdx
	leaq	(%r15,%rsi), %rax
	addq	%r8, %rdx
	addq	%rbp, %rsi
	salq	$4, %rax
	salq	$4, %rdx
	salq	$4, %rsi
	addq	%r9, %rax
	salq	$4, %rcx
	addq	(%r11), %rdx
	leaq	16(%r9,%rsi), %rsi
	.p2align 4,,10
	.p2align 3
.L141:
	fldt	(%rax)
	addq	$16, %rax
	fldt	(%rdx)
	addq	%rcx, %rdx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rsi, %rax
	jne	.L141
.L140:
	incq	%r8
	fstpt	(%rdi)
	addq	$16, %rdi
	cmpl	%r8d, %r13d
	jg	.L142
	incl	%ebx
	cmpl	%ebx, -36(%rsp)
	jne	.L145
.L143:
	movq	-32(%rsp), %rbx
	addq	%rbx, -56(%rsp)
	cmpl	%r13d, -24(%rsp)
	jg	.L146
	movl	-20(%rsp), %eax
	addq	-32(%rsp), %r15
	addl	%eax, %r14d
	addl	%eax, %r12d
	cmpl	%r14d, -24(%rsp)
	jg	.L139
.L151:
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE76:
	.size	bijk, .-bijk
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"Matrix 1 colums do not match Matrix 2 rows.\n"
	.align 8
.LC6:
	.string	"Result matrix rows do not match Matrix 1 rows.\n"
	.align 8
.LC7:
	.string	"Result matrix columns do not match Matrix 2 columns.\n"
	.align 8
.LC8:
	.string	"Here is the Matrix Multiplication result:"
	.align 8
.LC10:
	.string	"                          This function call took %.9f s\n"
	.align 8
.LC13:
	.string	"DEBUG: %.9Lf and %.9Lf were not the same.\n"
	.align 8
.LC14:
	.string	"MM1 and B&OH Solution are NOT the same!!!!!!!!!! :("
	.align 8
.LC15:
	.string	"MM1 and B&OH Solution are the same! This function call took %.9f s\n"
	.align 8
.LC16:
	.string	"Error: row and column sizes do not match"
	.align 8
.LC17:
	.string	"MM1 and MM8 (parallel blocked) Solution are the same! This function call took %.9f s\n"
	.align 8
.LC18:
	.string	"MM1 and MM8 (parallel blocked) Solution are NOT the same!!!!!!!!!! :("
	.align 8
.LC19:
	.string	"MM1 and Block Implementation are NOT the same!!!!!!!!!! :("
	.align 8
.LC20:
	.string	"MM1 and Block Implementation are the same! This function call took %.9f s\n"
	.align 8
.LC21:
	.string	"MM1 and MM2 are NOT the same!!!!!!!!!! :("
	.align 8
.LC22:
	.string	"MM1 and MM2 are the same! This function call took %.9f s\n"
	.align 8
.LC23:
	.string	"MM1 and MM3 are NOT the same!!!!!!!!!! :("
	.align 8
.LC24:
	.string	"MM1 and MM3 are the same! This function call took %.9f s\n"
	.align 8
.LC25:
	.string	"MM1 and MM4 are the same! This function call took %.9f s\n"
	.align 8
.LC26:
	.string	"MM1 and MM4 are NOT the same!!!!!!!!!! :("
	.align 8
.LC27:
	.string	"MM1 and MM5 are the same! This function call took %.9f s\n"
	.align 8
.LC28:
	.string	"MM1 and MM5 are NOT the same!!!!!!!!!! :("
	.align 8
.LC29:
	.string	"MM1 and MM6 are the same! This function call took %.9f s\n"
	.align 8
.LC30:
	.string	"MM1 and MM6 are NOT the same!!!!!!!!!! :("
	.align 8
.LC31:
	.string	"\n----------------------\n Tests complete! :) \n----------------------"
	.text
	.p2align 4
	.globl	run_tests
	.type	run_tests, @function
run_tests:
.LFB81:
	.cfi_startproc
	endbr64
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movl	$16000000, %edi
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	xorl	%ebx, %ebx
	subq	$488, %rsp
	.cfi_def_cfa_offset 544
	leaq	448(%rsp), %rdx
	vmovq	%rdx, %xmm2
	leaq	416(%rsp), %rdx
	movq	%fs:40, %rax
	movq	%rax, 472(%rsp)
	xorl	%eax, %eax
	vmovq	%rdx, %xmm4
	leaq	288(%rsp), %rax
	leaq	384(%rsp), %rdx
	vpinsrq	$1, %rax, %xmm2, %xmm1
	vmovq	%rdx, %xmm6
	leaq	352(%rsp), %rdx
	vmovdqa	%xmm1, 16(%rsp)
	vmovq	%rdx, %xmm1
	vpinsrq	$1, %rax, %xmm4, %xmm3
	vpinsrq	$1, %rax, %xmm6, %xmm5
	vpinsrq	$1, %rax, %xmm1, %xmm7
	movabsq	$4294968296000, %rax
	vmovdqa	%xmm3, 112(%rsp)
	vmovdqa	%xmm5, 128(%rsp)
	vmovdqa	%xmm7, 144(%rsp)
	movq	%rax, 296(%rsp)
	movl	$1000, 304(%rsp)
	call	malloc@PLT
	xorl	%edi, %edi
	movq	%rax, 288(%rsp)
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
.L154:
	movq	288(%rsp), %rbp
	call	rand@PLT
	movl	%eax, 8(%rsp)
	addq	%rbx, %rbp
	addq	$16, %rbx
	fildl	8(%rsp)
	fldt	.LC4(%rip)
	fmulp	%st, %st(1)
	fstpt	0(%rbp)
	cmpq	$16000000, %rbx
	jne	.L154
	movabsq	$4294968296000, %rax
	movl	$16000000, %edi
	movq	%rax, 328(%rsp)
	movl	$1000, 336(%rsp)
	call	malloc@PLT
	xorl	%edi, %edi
	movq	%rax, 320(%rsp)
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	xorl	%ebx, %ebx
.L155:
	movq	320(%rsp), %rbp
	call	rand@PLT
	movl	%eax, 8(%rsp)
	addq	%rbx, %rbp
	addq	$16, %rbx
	fildl	8(%rsp)
	fldt	.LC4(%rip)
	fmulp	%st, %st(1)
	fstpt	0(%rbp)
	cmpq	$16000000, %rbx
	jne	.L155
	movl	$16, %esi
	movl	$1000000, %edi
	call	calloc@PLT
	movq	%rax, 8(%rsp)
	call	clock@PLT
	movl	332(%rsp), %ecx
	movq	%rax, %rbx
	movq	288(%rsp), %r9
	movl	300(%rsp), %edx
	movq	320(%rsp), %r10
	movl	336(%rsp), %eax
	cmpl	%ecx, 304(%rsp)
	jne	.L299
	cmpl	$1000, %edx
	jne	.L298
	cmpl	$1000, %eax
	jne	.L296
	xorl	%edi, %edi
	xorl	%esi, %esi
	leaq	16(%r9), %r14
	leal	-1(%rcx), %r13d
.L159:
	movslq	%esi, %rax
	movq	%rax, %r8
	addq	%r13, %rax
	salq	$4, %r8
	salq	$4, %rax
	movq	%r10, %r11
	addq	%r9, %r8
	addq	%r14, %rax
	xorl	%ebp, %ebp
.L165:
	testl	%ecx, %ecx
	jle	.L163
	leal	0(%rbp,%rdi), %edx
	salq	$4, %rdx
	addq	8(%rsp), %rdx
	fldt	(%rdx)
	movq	%r11, %r15
	movq	%r8, %r12
	.p2align 4,,10
	.p2align 3
.L160:
	fldt	(%r12)
	addq	$16, %r12
	addq	$16000, %r15
	fldt	-16000(%r15)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%r12, %rax
	jne	.L160
	fstpt	(%rdx)
.L163:
	incl	%ebp
	addq	$16, %r11
	cmpl	$1000, %ebp
	jne	.L165
	addl	$1000, %edi
	addl	%ecx, %esi
	cmpl	$1000000, %edi
	jne	.L159
	movl	%edi, 84(%rsp)
	call	clock@PLT
	movq	%rax, %rbp
	leaq	.LC8(%rip), %rdi
	call	puts@PLT
	subq	%rbx, %rbp
	vxorpd	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	%rbp, %xmm1, %xmm0
	leaq	.LC10(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
	call	__printf_chk@PLT
	movl	$16, %esi
	movl	$1000000, %edi
	call	calloc@PLT
	movq	%rax, 64(%rsp)
	call	clock@PLT
	movl	304(%rsp), %r14d
	movq	%rax, 176(%rsp)
	movl	%r14d, %eax
	shrl	$31, %eax
	addl	%r14d, %eax
	sarl	%eax
	movl	%eax, %r12d
	movl	%r14d, %eax
	cltd
	idivl	%r12d
	imull	%r12d, %eax
	movl	%eax, 48(%rsp)
	testl	%eax, %eax
	jle	.L166
	movq	288(%rsp), %rbx
	movslq	336(%rsp), %rax
	movq	%rbx, 56(%rsp)
	kmovq	320(%rsp), %k1
	testl	%r14d, %r14d
	jle	.L166
	movl	%eax, %ecx
	imull	%r12d, %ecx
	salq	$4, %rax
	movq	%rax, 192(%rsp)
	kmovd	%ecx, %k0
	movslq	%r12d, %rcx
	movq	%rcx, 72(%rsp)
	imull	$1000, %r14d, %ecx
	leaq	16(%rbx), %rax
	movl	%r12d, 40(%rsp)
	movl	%ecx, 216(%rsp)
	movl	$0, 88(%rsp)
	movl	$0, 32(%rsp)
	movq	%rax, 160(%rsp)
	xorl	%r15d, %r15d
.L167:
	movslq	88(%rsp), %rax
	kmovq	%k1, %rbx
	salq	$4, %rax
	addq	%rbx, %rax
	movq	%rax, 184(%rsp)
	movl	40(%rsp), %eax
	movq	$0, 104(%rsp)
	decl	%eax
	subl	32(%rsp), %eax
	addq	%r15, %rax
	movq	%rax, 168(%rsp)
	xorl	%r13d, %r13d
.L174:
	movl	%r13d, %ebp
	addl	%r12d, %r13d
	cmpl	%r13d, %ebp
	jge	.L171
	movq	104(%rsp), %rax
	movq	64(%rsp), %rbx
	salq	$4, %rax
	leaq	(%rbx,%rax), %rdi
	addq	184(%rsp), %rax
	movq	%rax, 96(%rsp)
	xorl	%esi, %esi
	xorl	%ecx, %ecx
	.p2align 4,,10
	.p2align 3
.L173:
	movslq	%esi, %rax
	leaq	(%r15,%rax), %rdx
	addq	168(%rsp), %rax
	salq	$4, %rdx
	salq	$4, %rax
	movq	96(%rsp), %r9
	addq	56(%rsp), %rdx
	addq	160(%rsp), %rax
	movq	%rdi, %r8
	movl	%ebp, %r11d
	.p2align 4,,10
	.p2align 3
.L170:
	fldt	(%r8)
	movl	40(%rsp), %r10d
	cmpl	%r10d, 32(%rsp)
	jge	.L168
	movq	%r9, %rbx
	movq	%rdx, %r10
	.p2align 4,,10
	.p2align 3
.L169:
	fldt	(%r10)
	addq	$16, %r10
	fldt	(%rbx)
	addq	192(%rsp), %rbx
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%r10, %rax
	jne	.L169
.L168:
	incl	%r11d
	fstpt	(%r8)
	addq	$16, %r9
	addq	$16, %r8
	cmpl	%r13d, %r11d
	jne	.L170
	addl	$1000, %ecx
	addq	$16000, %rdi
	addl	%r14d, %esi
	cmpl	%ecx, 216(%rsp)
	jne	.L173
.L171:
	movq	72(%rsp), %rbx
	addq	%rbx, 104(%rsp)
	cmpl	%r13d, 48(%rsp)
	jg	.L174
	addl	%r12d, 32(%rsp)
	kmovd	%k0, %ecx
	addl	%r12d, 40(%rsp)
	addl	%ecx, 88(%rsp)
	movl	32(%rsp), %eax
	addq	72(%rsp), %r15
	cmpl	%eax, 48(%rsp)
	jg	.L167
.L166:
	call	clock@PLT
	subq	176(%rsp), %rax
	vxorpd	%xmm2, %xmm2, %xmm2
	vcvtsi2sdq	%rax, %xmm2, %xmm0
	xorl	%eax, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
.L178:
	movq	8(%rsp), %rbx
	fldt	(%rbx,%rax)
	movq	64(%rsp), %rbx
	fldt	(%rbx,%rax)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	ja	.L305
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L265
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rax
	cmpq	$16000000, %rax
	jne	.L178
	leaq	.LC15(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
.L177:
	movabsq	$4294968296000, %rax
	movl	$16, %esi
	movl	$1000000, %edi
	movq	%rax, 360(%rsp)
	movl	$1000, 368(%rsp)
	call	calloc@PLT
	movq	%rax, 352(%rsp)
	call	clock@PLT
	movl	332(%rsp), %ebx
	movq	%rax, %r15
	movl	300(%rsp), %edx
	movl	336(%rsp), %eax
	cmpl	%ebx, 304(%rsp)
	jne	.L299
	cmpl	364(%rsp), %edx
	jne	.L298
	cmpl	368(%rsp), %eax
	jne	.L296
	leaq	320(%rsp), %rax
	movq	%rax, 32(%rsp)
	leaq	256(%rsp), %rax
	movq	%rax, 40(%rsp)
	leaq	264(%rsp), %rax
	movq	%rax, 48(%rsp)
	leaq	272(%rsp), %rax
	movq	%rax, 56(%rsp)
	leaq	280(%rsp), %rax
	movq	%rax, 64(%rsp)
	xorl	%r12d, %r12d
	leaq	routine_80(%rip), %r13
	leaq	routine_81(%rip), %r14
	movq	%r15, %r9
	movl	%r12d, %r8d
.L181:
	movl	%r8d, 72(%rsp)
	xorl	%r15d, %r15d
	movl	%r15d, %ebp
.L185:
	vmovd	72(%rsp), %xmm3
	xorl	%ebx, %ebx
	vpinsrd	$1, %ebp, %xmm3, %xmm2
	vmovq	%xmm2, 88(%rsp)
.L182:
	movl	$40, %edi
	movq	%r9, 96(%rsp)
	call	malloc@PLT
	vmovdqa	144(%rsp), %xmm5
	movq	%rax, %r15
	vmovdqu	%xmm5, (%rax)
	movq	88(%rsp), %rcx
	movq	32(%rsp), %rax
	movq	%rcx, 24(%r15)
	movq	%rax, 16(%r15)
	movl	%ebx, 32(%r15)
	movl	$40, %edi
	call	malloc@PLT
	vmovdqa	144(%rsp), %xmm5
	movq	%rax, %r12
	vmovdqu	%xmm5, (%rax)
	movq	32(%rsp), %rax
	movl	%ebp, 28(%r12)
	movq	%rax, 16(%r12)
	movl	72(%rsp), %eax
	movl	%ebx, 32(%r12)
	movl	%eax, 24(%r12)
	movq	40(%rsp), %rdi
	xorl	%esi, %esi
	movq	%r15, %rcx
	movq	%r13, %rdx
	call	pthread_create@PLT
	movq	48(%rsp), %rdi
	movq	%r12, %rcx
	movq	%r14, %rdx
	xorl	%esi, %esi
	call	pthread_create@PLT
	movq	56(%rsp), %rsi
	movq	256(%rsp), %rdi
	call	pthread_join@PLT
	movq	64(%rsp), %rsi
	movq	264(%rsp), %rdi
	call	pthread_join@PLT
	cmpl	$1, %ebx
	movq	96(%rsp), %r9
	jne	.L263
	cmpl	$1, %ebp
	je	.L183
	movl	$1, %ebp
	jmp	.L185
.L263:
	movl	$1, %ebx
	jmp	.L182
.L183:
	movl	72(%rsp), %r8d
	cmpl	$1, %r8d
	je	.L184
	movl	$1, %r8d
	jmp	.L181
.L305:
	fstp	%st(0)
.L265:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	leaq	.LC14(%rip), %rdi
	call	puts@PLT
	jmp	.L177
.L184:
	movq	%r9, %r15
	call	clock@PLT
	cmpl	$1000, 364(%rsp)
	je	.L186
	cmpl	$1000, 368(%rsp)
	jne	.L300
.L187:
	leaq	.LC18(%rip), %rdi
	call	puts@PLT
.L191:
	movl	$16, %esi
	movl	$1000000, %edi
	call	calloc@PLT
	movq	%rax, %r15
	call	clock@PLT
	movq	%rax, 168(%rsp)
	movl	304(%rsp), %r14d
	movq	288(%rsp), %rax
	movl	300(%rsp), %edx
	movq	%rax, 72(%rsp)
	kmovq	320(%rsp), %k4
	movl	336(%rsp), %eax
	cmpl	332(%rsp), %r14d
	jne	.L299
	cmpl	$1000, %edx
	jne	.L298
	cmpl	$1000, %eax
	jne	.L296
	movl	%r14d, %eax
	shrl	$31, %eax
	addl	%r14d, %eax
	sarl	%eax
	movl	%eax, %r12d
	imull	$500, %r14d, %eax
	movl	$0, 88(%rsp)
	movl	$500, %r13d
	kmovd	%eax, %k3
	imull	$1000, %r12d, %eax
	movl	%r13d, %ebp
	kmovd	%eax, %k2
	movq	72(%rsp), %rax
	addq	$16, %rax
	kmovq	%rax, %k1
	movslq	%r12d, %rax
	kmovq	%rax, %k0
.L195:
	leal	-500(%rbp), %eax
	movl	%eax, 184(%rsp)
	movl	%r14d, 144(%rsp)
	movl	%ebp, 160(%rsp)
	xorl	%r13d, %r13d
.L203:
	movl	%r13d, %eax
	addl	$500, %eax
	movl	%r13d, 192(%rsp)
	movl	%r13d, 176(%rsp)
	movl	$0, 96(%rsp)
	movl	$2, 216(%rsp)
	movl	%eax, 220(%rsp)
	movl	%r12d, %r11d
	xorl	%ebp, %ebp
	xorl	%r14d, %r14d
.L200:
	movslq	96(%rsp), %rax
	kmovq	%k4, %rbx
	addq	%r13, %rax
	salq	$4, %rax
	addq	%rbx, %rax
	movq	%rax, 200(%rsp)
	movl	88(%rsp), %eax
	movl	184(%rsp), %r9d
	movl	%eax, 104(%rsp)
	leal	-1(%r11), %eax
	subl	%r14d, %eax
	addq	%rbp, %rax
	movq	%rax, 208(%rsp)
.L199:
	movslq	104(%rsp), %rax
	movq	208(%rsp), %rbx
	imull	$1000, %r9d, %r8d
	leaq	(%rbx,%rax), %rcx
	leaq	0(%rbp,%rax), %rdi
	salq	$4, %rdi
	salq	$4, %rcx
	movq	200(%rsp), %r10
	movl	176(%rsp), %ebx
	kmovq	%k1, %rax
	addl	192(%rsp), %r8d
	addq	72(%rsp), %rdi
	addq	%rax, %rcx
	.p2align 4,,10
	.p2align 3
.L198:
	cmpl	%r11d, %r14d
	jge	.L196
	movslq	%r8d, %rax
	salq	$4, %rax
	addq	%r15, %rax
	fldt	(%rax)
	movq	%r10, %rsi
	movq	%rdi, %rdx
	.p2align 4,,10
	.p2align 3
.L197:
	fldt	(%rdx)
	addq	$16, %rdx
	addq	$16000, %rsi
	fldt	-16000(%rsi)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rdx, %rcx
	jne	.L197
	fstpt	(%rax)
.L196:
	incl	%ebx
	addq	$16, %r10
	incl	%r8d
	cmpl	220(%rsp), %ebx
	jl	.L198
	movl	144(%rsp), %ebx
	incl	%r9d
	addl	%ebx, 104(%rsp)
	cmpl	160(%rsp), %r9d
	jl	.L199
	addl	%r12d, %r14d
	addl	%r12d, %r11d
	kmovd	%k2, %ebx
	kmovq	%k0, %rax
	addl	%ebx, 96(%rsp)
	addq	%rax, %rbp
	cmpl	$1, 216(%rsp)
	jne	.L264
	addq	$500, %r13
	cmpq	$1000, %r13
	jne	.L203
	movl	160(%rsp), %ebp
	kmovd	%k3, %ebx
	addl	$500, %ebp
	addl	%ebx, 88(%rsp)
	movl	144(%rsp), %r14d
	cmpl	$1500, %ebp
	jne	.L195
	call	clock@PLT
	subq	168(%rsp), %rax
	vxorpd	%xmm1, %xmm1, %xmm1
	vcvtsi2sdq	%rax, %xmm1, %xmm0
	xorl	%eax, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
.L207:
	movq	8(%rsp), %rbx
	fldt	(%rbx,%rax)
	fldt	(%r15,%rax)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	ja	.L306
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L267
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rax
	cmpq	$16000000, %rax
	jne	.L207
	leaq	.LC20(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
.L206:
	movl	$16, %esi
	movl	$1000000, %edi
	call	calloc@PLT
	movq	%rax, %rbp
	call	clock@PLT
	movl	304(%rsp), %esi
	movq	%rax, %r13
	movq	288(%rsp), %rdx
	movl	300(%rsp), %edi
	movq	320(%rsp), %rax
	movl	336(%rsp), %ecx
	cmpl	332(%rsp), %esi
	jne	.L299
	cmpl	$1000, %edi
	jne	.L298
	cmpl	$1000, %ecx
	jne	.L296
	testl	%esi, %esi
	jle	.L211
	movslq	%esi, %rcx
	salq	$4, %rcx
	movq	%rcx, %r12
	xorl	%ebx, %ebx
.L212:
	movq	%rbp, %rdi
	movq	%rax, %r9
	xorl	%r8d, %r8d
.L215:
	fldt	(%r9)
	movq	%rdx, %r10
	movq	%rdi, %rcx
	leaq	16000000(%rdi), %r11
.L213:
	fldt	(%r10)
	addq	$16000, %rcx
	addq	%r12, %r10
	fmul	%st(1), %st
	fldt	-16000(%rcx)
	faddp	%st, %st(1)
	fstpt	-16000(%rcx)
	cmpq	%rcx, %r11
	jne	.L213
	fstp	%st(0)
	incl	%r8d
	addq	$16, %r9
	addq	$16, %rdi
	cmpl	$1000, %r8d
	jne	.L215
	incl	%ebx
	addq	$16, %rdx
	addq	$16000, %rax
	cmpl	%ebx, %esi
	jne	.L212
.L211:
	call	clock@PLT
	subq	%r13, %rax
	vxorpd	%xmm2, %xmm2, %xmm2
	vcvtsi2sdq	%rax, %xmm2, %xmm0
	xorl	%eax, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
.L219:
	movq	8(%rsp), %rcx
	fldt	(%rcx,%rax)
	fldt	0(%rbp,%rax)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomi	%st(1), %st
	fstp	%st(1)
	ja	.L307
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L268
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rax
	cmpq	$16000000, %rax
	jne	.L219
	leaq	.LC22(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
.L218:
	movl	$16, %esi
	movl	$1000000, %edi
	call	calloc@PLT
	movq	%rax, %rbp
	call	clock@PLT
	movl	304(%rsp), %r8d
	movq	%rax, %r12
	movq	288(%rsp), %rbx
	movl	300(%rsp), %edx
	movq	320(%rsp), %rsi
	movl	336(%rsp), %eax
	cmpl	332(%rsp), %r8d
	jne	.L299
	cmpl	$1000, %edx
	jne	.L298
	cmpl	$1000, %eax
	jne	.L296
	xorl	%r9d, %r9d
	leal	-1(%r8), %r14d
	leaq	16(%rbx), %r13
.L223:
	movl	%r9d, %edi
	xorl	%r10d, %r10d
.L229:
	testl	%r8d, %r8d
	jle	.L227
	movslq	%edi, %rdx
	salq	$4, %rdx
	movslq	%r10d, %rax
	addq	%rbp, %rdx
	movq	%rax, %rcx
	fldt	(%rdx)
	addq	%r14, %rax
	salq	$4, %rcx
	salq	$4, %rax
	addq	%rbx, %rcx
	addq	%r13, %rax
	movq	%rsi, %r11
	.p2align 4,,10
	.p2align 3
.L224:
	fldt	(%rcx)
	addq	$16, %rcx
	addq	$16000, %r11
	fldt	-16000(%r11)
	fmulp	%st, %st(1)
	faddp	%st, %st(1)
	cmpq	%rax, %rcx
	jne	.L224
	fstpt	(%rdx)
.L227:
	addl	$1000, %edi
	addl	%r8d, %r10d
	cmpl	84(%rsp), %edi
	jne	.L229
	leal	1(%rdi), %eax
	incl	%r9d
	movl	%eax, 84(%rsp)
	addq	$16, %rsi
	cmpl	$1000, %r9d
	jne	.L223
	call	clock@PLT
	subq	%r12, %rax
	vxorpd	%xmm3, %xmm3, %xmm3
	vcvtsi2sdq	%rax, %xmm3, %xmm0
	xorl	%eax, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
.L233:
	movq	8(%rsp), %rbx
	fldt	(%rbx,%rax)
	fldt	0(%rbp,%rax)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	ja	.L308
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L269
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rax
	cmpq	$16000000, %rax
	jne	.L233
	leaq	.LC24(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	call	__printf_chk@PLT
.L232:
	movabsq	$4294968296000, %rax
	movl	$16, %esi
	movl	$1000000, %edi
	movq	%rax, 392(%rsp)
	movl	$1000, 400(%rsp)
	call	calloc@PLT
	movq	%rax, 384(%rsp)
	call	clock@PLT
	movl	332(%rsp), %ecx
	movq	%rax, %rbx
	movl	300(%rsp), %edx
	movl	336(%rsp), %eax
	cmpl	%ecx, 304(%rsp)
	jne	.L299
	cmpl	396(%rsp), %edx
	jne	.L298
	cmpl	400(%rsp), %eax
	jne	.L296
	movl	$24, %edi
	call	malloc@PLT
	movq	32(%rsp), %r15
	vmovdqa	128(%rsp), %xmm6
	movq	%r15, 16(%rax)
	vmovdqu	%xmm6, (%rax)
	movl	$24, %edi
	movq	%rax, %r13
	call	malloc@PLT
	movq	%r15, 16(%rax)
	vmovdqa	128(%rsp), %xmm6
	movq	40(%rsp), %rdi
	vmovdqu	%xmm6, (%rax)
	xorl	%esi, %esi
	movq	%r13, %rcx
	leaq	routine_40(%rip), %rdx
	movq	%rax, %r12
	call	pthread_create@PLT
	movq	48(%rsp), %rdi
	movq	%r12, %rcx
	leaq	routine_41(%rip), %rdx
	xorl	%esi, %esi
	call	pthread_create@PLT
	movq	56(%rsp), %rsi
	movq	256(%rsp), %rdi
	call	pthread_join@PLT
	movq	64(%rsp), %rsi
	movq	264(%rsp), %rdi
	call	pthread_join@PLT
	call	clock@PLT
	cmpl	$1000, 396(%rsp)
	je	.L237
	cmpl	$1000, 400(%rsp)
	jne	.L301
.L238:
	leaq	.LC26(%rip), %rdi
	call	puts@PLT
.L242:
	movabsq	$4294968296000, %rax
	movl	$16, %esi
	movl	$1000000, %edi
	movq	%rax, 424(%rsp)
	movl	$1000, 432(%rsp)
	call	calloc@PLT
	movq	%rax, 416(%rsp)
	call	clock@PLT
	movl	332(%rsp), %ecx
	movq	%rax, %rbx
	movl	300(%rsp), %edx
	movl	336(%rsp), %eax
	cmpl	%ecx, 304(%rsp)
	jne	.L299
	cmpl	428(%rsp), %edx
	jne	.L298
	cmpl	432(%rsp), %eax
	jne	.L296
	movl	$24, %edi
	call	malloc@PLT
	movq	32(%rsp), %r14
	vmovdqa	112(%rsp), %xmm7
	movq	%r14, 16(%rax)
	vmovdqu	%xmm7, (%rax)
	movl	$24, %edi
	movq	%rax, %r13
	call	malloc@PLT
	movq	%r14, 16(%rax)
	vmovdqa	112(%rsp), %xmm7
	movq	40(%rsp), %rdi
	vmovdqu	%xmm7, (%rax)
	xorl	%esi, %esi
	movq	%r13, %rcx
	leaq	routine_50(%rip), %rdx
	movq	%rax, %r12
	call	pthread_create@PLT
	movq	48(%rsp), %rdi
	movq	%r12, %rcx
	leaq	routine_51(%rip), %rdx
	xorl	%esi, %esi
	call	pthread_create@PLT
	movq	56(%rsp), %rsi
	movq	256(%rsp), %rdi
	call	pthread_join@PLT
	movq	64(%rsp), %rsi
	movq	264(%rsp), %rdi
	call	pthread_join@PLT
	call	clock@PLT
	cmpl	$1000, 428(%rsp)
	je	.L246
	cmpl	$1000, 432(%rsp)
	jne	.L302
.L247:
	leaq	.LC28(%rip), %rdi
	call	puts@PLT
.L251:
	movabsq	$4294968296000, %rax
	movl	$16, %esi
	movl	$1000000, %edi
	movq	%rax, 456(%rsp)
	movl	$1000, 464(%rsp)
	call	calloc@PLT
	movq	%rax, 448(%rsp)
	call	clock@PLT
	movl	332(%rsp), %ecx
	movq	%rax, %rbx
	movl	300(%rsp), %edx
	movl	336(%rsp), %eax
	cmpl	%ecx, 304(%rsp)
	jne	.L299
	cmpl	460(%rsp), %edx
	jne	.L298
	cmpl	464(%rsp), %eax
	jne	.L296
	movl	$24, %edi
	call	malloc@PLT
	movq	32(%rsp), %rbp
	vmovdqa	16(%rsp), %xmm4
	movq	%rbp, 16(%rax)
	vmovdqu	%xmm4, (%rax)
	movl	$24, %edi
	movq	%rax, %r15
	call	malloc@PLT
	movq	%rbp, 16(%rax)
	vmovdqa	16(%rsp), %xmm4
	movl	$24, %edi
	vmovdqu	%xmm4, (%rax)
	movq	%rax, %r14
	call	malloc@PLT
	movq	%rbp, 16(%rax)
	vmovdqa	16(%rsp), %xmm4
	movl	$24, %edi
	vmovdqu	%xmm4, (%rax)
	movq	%rax, %r13
	call	malloc@PLT
	movq	%rbp, 16(%rax)
	vmovdqa	16(%rsp), %xmm4
	xorl	%esi, %esi
	vmovdqu	%xmm4, (%rax)
	leaq	224(%rsp), %rdi
	movq	%r15, %rcx
	leaq	routine_60(%rip), %rdx
	movq	%rax, %r12
	call	pthread_create@PLT
	xorl	%esi, %esi
	leaq	232(%rsp), %rdi
	movq	%r14, %rcx
	leaq	routine_61(%rip), %rdx
	call	pthread_create@PLT
	xorl	%esi, %esi
	leaq	240(%rsp), %rdi
	movq	%r13, %rcx
	leaq	routine_62(%rip), %rdx
	call	pthread_create@PLT
	movq	%r12, %rcx
	leaq	routine_63(%rip), %rdx
	xorl	%esi, %esi
	leaq	248(%rsp), %rdi
	call	pthread_create@PLT
	movq	40(%rsp), %rsi
	movq	224(%rsp), %rdi
	call	pthread_join@PLT
	movq	48(%rsp), %rsi
	movq	232(%rsp), %rdi
	call	pthread_join@PLT
	movq	56(%rsp), %rsi
	movq	240(%rsp), %rdi
	call	pthread_join@PLT
	movq	64(%rsp), %rsi
	movq	248(%rsp), %rdi
	call	pthread_join@PLT
	call	clock@PLT
	cmpl	$1000, 460(%rsp)
	je	.L255
	cmpl	$1000, 464(%rsp)
	jne	.L303
.L256:
	leaq	.LC30(%rip), %rdi
	call	puts@PLT
.L260:
	leaq	.LC31(%rip), %rdi
	call	puts@PLT
	movq	472(%rsp), %rax
	subq	%fs:40, %rax
	jne	.L304
	addq	$488, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L264:
	.cfi_restore_state
	movl	$1, 216(%rsp)
	jmp	.L200
.L307:
	fstp	%st(0)
.L268:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	leaq	.LC21(%rip), %rdi
	call	puts@PLT
	jmp	.L218
.L306:
	fstp	%st(0)
.L267:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	leaq	.LC19(%rip), %rdi
	call	puts@PLT
	jmp	.L206
.L308:
	fstp	%st(0)
.L269:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	leaq	.LC23(%rip), %rdi
	call	puts@PLT
	jmp	.L232
.L303:
	leaq	.LC16(%rip), %rdi
	call	puts@PLT
	jmp	.L256
.L255:
	cmpl	$1000, 464(%rsp)
	jne	.L256
	cmpl	$1000000, 456(%rsp)
	movq	448(%rsp), %rcx
	jne	.L256
	xorl	%edx, %edx
.L259:
	movq	8(%rsp), %rsi
	fldt	(%rsi,%rdx)
	fldt	(%rcx,%rdx)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	ja	.L309
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L272
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rdx
	cmpq	$16000000, %rdx
	jne	.L259
	subq	%rbx, %rax
	vxorpd	%xmm7, %xmm7, %xmm7
	vcvtsi2sdq	%rax, %xmm7, %xmm0
	leaq	.LC29(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
	call	__printf_chk@PLT
	jmp	.L260
.L302:
	leaq	.LC16(%rip), %rdi
	call	puts@PLT
	jmp	.L247
.L246:
	cmpl	$1000, 432(%rsp)
	jne	.L247
	cmpl	$1000000, 424(%rsp)
	movq	416(%rsp), %rcx
	jne	.L247
	xorl	%edx, %edx
.L250:
	movq	8(%rsp), %rsi
	fldt	(%rsi,%rdx)
	fldt	(%rcx,%rdx)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomi	%st(1), %st
	fstp	%st(1)
	ja	.L310
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L271
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rdx
	cmpq	$16000000, %rdx
	jne	.L250
	subq	%rbx, %rax
	vxorpd	%xmm6, %xmm6, %xmm6
	vcvtsi2sdq	%rax, %xmm6, %xmm0
	leaq	.LC27(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
	call	__printf_chk@PLT
	jmp	.L251
.L301:
	leaq	.LC16(%rip), %rdi
	call	puts@PLT
	jmp	.L238
.L237:
	cmpl	$1000, 400(%rsp)
	jne	.L238
	cmpl	$1000000, 392(%rsp)
	movq	384(%rsp), %rcx
	jne	.L238
	xorl	%edx, %edx
.L241:
	movq	8(%rsp), %rsi
	fldt	(%rsi,%rdx)
	fldt	(%rcx,%rdx)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomi	%st(1), %st
	fstp	%st(1)
	ja	.L311
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L270
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rdx
	cmpq	$16000000, %rdx
	jne	.L241
	subq	%rbx, %rax
	vxorpd	%xmm5, %xmm5, %xmm5
	vcvtsi2sdq	%rax, %xmm5, %xmm0
	leaq	.LC25(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
	call	__printf_chk@PLT
	jmp	.L242
.L300:
	leaq	.LC16(%rip), %rdi
	call	puts@PLT
	jmp	.L187
.L186:
	cmpl	$1000, 368(%rsp)
	jne	.L187
	cmpl	$1000000, 360(%rsp)
	movq	352(%rsp), %rcx
	jne	.L187
	xorl	%edx, %edx
.L190:
	movq	8(%rsp), %rbx
	fldt	(%rbx,%rdx)
	fldt	(%rcx,%rdx)
	fld	%st(1)
	fsub	%st(1), %st
	fldl	.LC11(%rip)
	fcomip	%st(1), %st
	ja	.L312
	fldl	.LC12(%rip)
	fxch	%st(1)
	fcomip	%st(1), %st
	fstp	%st(0)
	ja	.L266
	fstp	%st(0)
	fstp	%st(0)
	addq	$16, %rdx
	cmpq	$16000000, %rdx
	jne	.L190
	subq	%r15, %rax
	vxorpd	%xmm3, %xmm3, %xmm3
	vcvtsi2sdq	%rax, %xmm3, %xmm0
	leaq	.LC17(%rip), %rsi
	movl	$1, %edi
	movl	$1, %eax
	vmulsd	.LC9(%rip), %xmm0, %xmm0
	call	__printf_chk@PLT
	jmp	.L191
.L311:
	fstp	%st(0)
.L270:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	jmp	.L238
.L310:
	fstp	%st(0)
.L271:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	jmp	.L247
.L309:
	fstp	%st(0)
.L272:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	jmp	.L256
.L312:
	fstp	%st(0)
.L266:
	subq	$32, %rsp
	.cfi_def_cfa_offset 576
	fstpt	16(%rsp)
	leaq	.LC13(%rip), %rsi
	movl	$1, %edi
	xorl	%eax, %eax
	fstpt	(%rsp)
	call	__printf_chk@PLT
	addq	$32, %rsp
	.cfi_def_cfa_offset 544
	jmp	.L187
.L299:
	movq	stderr(%rip), %rcx
	leaq	.LC5(%rip), %rdi
	movl	$44, %edx
	movl	$1, %esi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L304:
	call	__stack_chk_fail@PLT
.L296:
	movq	stderr(%rip), %rcx
	leaq	.LC7(%rip), %rdi
	movl	$53, %edx
	movl	$1, %esi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
.L298:
	movq	stderr(%rip), %rcx
	leaq	.LC6(%rip), %rdi
	movl	$47, %edx
	movl	$1, %esi
	call	fwrite@PLT
	movl	$1, %edi
	call	exit@PLT
	.cfi_endproc
.LFE81:
	.size	run_tests, .-run_tests
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC3:
	.long	2
	.long	-2147483647
	.long	16352
	.long	0
	.align 16
.LC4:
	.long	-1879048189
	.long	-939524095
	.long	16358
	.long	0
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC9:
	.long	-1598689907
	.long	1051772663
	.align 8
.LC11:
	.long	-512138091
	.long	-1113195137
	.align 8
.LC12:
	.long	-512138091
	.long	1034288511
	.ident	"GCC: (Ubuntu 11.4.0-1ubuntu1~22.04.2) 11.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
