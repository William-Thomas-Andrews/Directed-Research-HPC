	.file	"test.c"
	.text
	.p2align 4
	.globl	vector_add_scalar
	.type	vector_add_scalar, @function
vector_add_scalar:
.LFB5512:
	.cfi_startproc
	endbr64
	testl	%ecx, %ecx
	jle	.L28
	leaq	4(%rdi), %r10
	movq	%rdx, %r8
	leal	-1(%rcx), %eax
	movl	%ecx, %r9d
	subq	%r10, %r8
	cmpq	$56, %r8
	seta	%r10b
	cmpl	$6, %eax
	seta	%r8b
	testb	%r8b, %r10b
	je	.L3
	leaq	4(%rsi), %r10
	movq	%rdx, %r8
	subq	%r10, %r8
	cmpq	$56, %r8
	jbe	.L3
	cmpl	$14, %eax
	jbe	.L11
	movl	%ecx, %r8d
	xorl	%eax, %eax
	shrl	$4, %r8d
	salq	$6, %r8
	.p2align 4,,10
	.p2align 3
.L5:
	vmovups	(%rdi,%rax), %zmm1
	vaddps	(%rsi,%rax), %zmm1, %zmm0
	vmovups	%zmm0, (%rdx,%rax)
	addq	$64, %rax
	cmpq	%r8, %rax
	jne	.L5
	movl	%ecx, %eax
	andl	$-16, %eax
	movl	%eax, %r8d
	cmpl	%eax, %ecx
	je	.L27
	movl	%ecx, %r9d
	subl	%eax, %r9d
	leal	-1(%r9), %r10d
	cmpl	$6, %r10d
	jbe	.L7
.L4:
	vmovups	(%rdi,%rax,4), %ymm2
	vaddps	(%rsi,%rax,4), %ymm2, %ymm0
	vmovups	%ymm0, (%rdx,%rax,4)
	movl	%r9d, %eax
	andl	$-8, %eax
	addl	%eax, %r8d
	cmpl	%eax, %r9d
	je	.L27
.L7:
	movslq	%r8d, %r9
	vmovss	(%rdi,%r9,4), %xmm0
	vaddss	(%rsi,%r9,4), %xmm0, %xmm0
	leaq	0(,%r9,4), %rax
	vmovss	%xmm0, (%rdx,%r9,4)
	leal	1(%r8), %r9d
	cmpl	%r9d, %ecx
	jle	.L27
	vmovss	4(%rdi,%rax), %xmm0
	vaddss	4(%rsi,%rax), %xmm0, %xmm0
	leal	2(%r8), %r9d
	vmovss	%xmm0, 4(%rdx,%rax)
	cmpl	%r9d, %ecx
	jle	.L27
	vmovss	8(%rdi,%rax), %xmm0
	vaddss	8(%rsi,%rax), %xmm0, %xmm0
	leal	3(%r8), %r9d
	vmovss	%xmm0, 8(%rdx,%rax)
	cmpl	%r9d, %ecx
	jle	.L27
	vmovss	12(%rdi,%rax), %xmm0
	vaddss	12(%rsi,%rax), %xmm0, %xmm0
	leal	4(%r8), %r9d
	vmovss	%xmm0, 12(%rdx,%rax)
	cmpl	%r9d, %ecx
	jle	.L27
	vmovss	16(%rdi,%rax), %xmm0
	vaddss	16(%rsi,%rax), %xmm0, %xmm0
	leal	5(%r8), %r9d
	vmovss	%xmm0, 16(%rdx,%rax)
	cmpl	%r9d, %ecx
	jle	.L27
	vmovss	20(%rdi,%rax), %xmm0
	vaddss	20(%rsi,%rax), %xmm0, %xmm0
	addl	$6, %r8d
	vmovss	%xmm0, 20(%rdx,%rax)
	cmpl	%r8d, %ecx
	jle	.L27
	vmovss	24(%rdi,%rax), %xmm0
	vaddss	24(%rsi,%rax), %xmm0, %xmm0
	vmovss	%xmm0, 24(%rdx,%rax)
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L27:
	vzeroupper
.L28:
	ret
	.p2align 4,,10
	.p2align 3
.L3:
	movl	%ecx, %ecx
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L9:
	vmovss	(%rdi,%rax,4), %xmm0
	vaddss	(%rsi,%rax,4), %xmm0, %xmm0
	vmovss	%xmm0, (%rdx,%rax,4)
	addq	$1, %rax
	cmpq	%rcx, %rax
	jne	.L9
	ret
.L11:
	xorl	%eax, %eax
	xorl	%r8d, %r8d
	jmp	.L4
	.cfi_endproc
.LFE5512:
	.size	vector_add_scalar, .-vector_add_scalar
	.p2align 4
	.globl	vector_add_avx2
	.type	vector_add_avx2, @function
vector_add_avx2:
.LFB5513:
	.cfi_startproc
	endbr64
	movl	%ecx, %r8d
	subl	$7, %ecx
	testl	%ecx, %ecx
	jle	.L40
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L32:
	vmovups	(%rdi,%rax,4), %ymm1
	vaddps	(%rsi,%rax,4), %ymm1, %ymm0
	vmovups	%ymm0, (%rdx,%rax,4)
	addq	$8, %rax
	cmpl	%eax, %ecx
	jg	.L32
	leal	-8(%r8), %eax
	shrl	$3, %eax
	leal	8(,%rax,8), %eax
.L31:
	cmpl	%eax, %r8d
	jle	.L51
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movslq	%eax, %r11
	movl	%r8d, %r9d
	leaq	0(,%r11,4), %rcx
	subl	%eax, %r9d
	leaq	4(%rcx), %r10
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	leaq	(%rdi,%r10), %r13
	addq	%rsi, %r10
	pushq	%r12
	.cfi_offset 12, -48
	leal	-1(%r9), %r12d
	pushq	%rbx
	.cfi_offset 3, -56
	leaq	(%rdx,%rcx), %rbx
	movq	%rbx, %r14
	subq	%r13, %r14
	cmpq	$24, %r14
	movq	%rbx, %r14
	seta	%r15b
	subq	%r10, %r14
	cmpq	$24, %r14
	seta	%r14b
	testb	%r14b, %r15b
	je	.L34
	cmpl	$2, %r12d
	jbe	.L34
	cmpl	$6, %r12d
	jbe	.L41
	vmovups	(%rdi,%r11,4), %ymm3
	vaddps	(%rsi,%r11,4), %ymm3, %ymm0
	movl	%r9d, %ecx
	andl	$-8, %ecx
	addl	%ecx, %eax
	vmovups	%ymm0, (%rbx)
	cmpl	%ecx, %r9d
	je	.L49
	subl	%ecx, %r9d
	leal	-1(%r9), %r10d
	cmpl	$2, %r10d
	jbe	.L37
.L35:
	addq	%r11, %rcx
	vmovups	(%rdi,%rcx,4), %xmm2
	vaddps	(%rsi,%rcx,4), %xmm2, %xmm0
	vmovups	%xmm0, (%rdx,%rcx,4)
	movl	%r9d, %ecx
	andl	$-4, %ecx
	addl	%ecx, %eax
	cmpl	%ecx, %r9d
	je	.L49
.L37:
	movslq	%eax, %r9
	vmovss	(%rdi,%r9,4), %xmm0
	vaddss	(%rsi,%r9,4), %xmm0, %xmm0
	leaq	0(,%r9,4), %rcx
	vmovss	%xmm0, (%rdx,%r9,4)
	leal	1(%rax), %r9d
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	4(%rdi,%rcx), %xmm0
	vaddss	4(%rsi,%rcx), %xmm0, %xmm0
	addl	$2, %eax
	vmovss	%xmm0, 4(%rdx,%rcx)
	cmpl	%eax, %r8d
	jle	.L49
	vmovss	8(%rdi,%rcx), %xmm0
	vaddss	8(%rsi,%rcx), %xmm0, %xmm0
	vmovss	%xmm0, 8(%rdx,%rcx)
.L49:
	vzeroupper
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L34:
	.cfi_restore_state
	vmovss	(%rdi,%r11,4), %xmm0
	vaddss	(%rsi,%r11,4), %xmm0, %xmm0
	leal	1(%rax), %r9d
	vmovss	%xmm0, (%rbx)
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	0(%r13), %xmm0
	vaddss	(%r10), %xmm0, %xmm0
	leal	2(%rax), %r9d
	vmovss	%xmm0, 4(%rdx,%rcx)
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	8(%rdi,%rcx), %xmm0
	vaddss	8(%rsi,%rcx), %xmm0, %xmm0
	leal	3(%rax), %r9d
	vmovss	%xmm0, 8(%rdx,%rcx)
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	12(%rdi,%rcx), %xmm0
	vaddss	12(%rsi,%rcx), %xmm0, %xmm0
	leal	4(%rax), %r9d
	vmovss	%xmm0, 12(%rdx,%rcx)
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	16(%rdi,%rcx), %xmm0
	vaddss	16(%rsi,%rcx), %xmm0, %xmm0
	leal	5(%rax), %r9d
	vmovss	%xmm0, 16(%rdx,%rcx)
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	20(%rdi,%rcx), %xmm0
	vaddss	20(%rsi,%rcx), %xmm0, %xmm0
	leal	6(%rax), %r9d
	vmovss	%xmm0, 20(%rdx,%rcx)
	cmpl	%r9d, %r8d
	jle	.L49
	vmovss	24(%rdi,%rcx), %xmm0
	vaddss	24(%rsi,%rcx), %xmm0, %xmm0
	addl	$7, %eax
	vmovss	%xmm0, 24(%rdx,%rcx)
	cmpl	%eax, %r8d
	jle	.L49
	vmovss	28(%rdi,%rcx), %xmm0
	vaddss	28(%rsi,%rcx), %xmm0, %xmm0
	vmovss	%xmm0, 28(%rdx,%rcx)
	jmp	.L49
	.p2align 4,,10
	.p2align 3
.L51:
	.cfi_def_cfa 7, 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L40:
	xorl	%eax, %eax
	jmp	.L31
.L41:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	xorl	%ecx, %ecx
	jmp	.L35
	.cfi_endproc
.LFE5513:
	.size	vector_add_avx2, .-vector_add_avx2
	.p2align 4
	.globl	vector_add_avx512
	.type	vector_add_avx512, @function
vector_add_avx512:
.LFB5514:
	.cfi_startproc
	endbr64
	movq	%rdx, %r9
	cmpl	$15, %ecx
	jle	.L63
	leal	-16(%rcx), %eax
	andl	$-16, %eax
	addl	$16, %eax
	cmpl	%eax, %ecx
	jle	.L81
.L84:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movslq	%eax, %r11
	movl	%ecx, %r10d
	leaq	0(,%r11,4), %rdx
	subl	%eax, %r10d
	leaq	4(%rdx), %r8
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	leaq	(%rdi,%r8), %r13
	addq	%rsi, %r8
	pushq	%r12
	.cfi_offset 12, -48
	leal	-1(%r10), %r12d
	pushq	%rbx
	.cfi_offset 3, -56
	leaq	(%r9,%rdx), %rbx
	movq	%rbx, %r14
	subq	%r13, %r14
	cmpq	$56, %r14
	movq	%rbx, %r14
	seta	%r15b
	subq	%r8, %r14
	cmpq	$56, %r14
	seta	%r14b
	testb	%r14b, %r15b
	je	.L57
	cmpl	$6, %r12d
	jbe	.L57
	cmpl	$14, %r12d
	jbe	.L64
	vmovups	(%rdi,%r11,4), %zmm2
	vaddps	(%rsi,%r11,4), %zmm2, %zmm0
	movl	%r10d, %edx
	andl	$-16, %edx
	addl	%edx, %eax
	vmovups	%zmm0, (%rbx)
	cmpl	%edx, %r10d
	je	.L78
	subl	%edx, %r10d
	leal	-1(%r10), %r8d
	cmpl	$6, %r8d
	jbe	.L60
.L58:
	addq	%r11, %rdx
	vmovups	(%rdi,%rdx,4), %ymm1
	vaddps	(%rsi,%rdx,4), %ymm1, %ymm0
	vmovups	%ymm0, (%r9,%rdx,4)
	movl	%r10d, %edx
	andl	$-8, %edx
	addl	%edx, %eax
	cmpl	%edx, %r10d
	je	.L78
.L60:
	movslq	%eax, %r8
	vmovss	(%rdi,%r8,4), %xmm0
	vaddss	(%rsi,%r8,4), %xmm0, %xmm0
	leaq	0(,%r8,4), %rdx
	vmovss	%xmm0, (%r9,%r8,4)
	leal	1(%rax), %r8d
	cmpl	%r8d, %ecx
	jle	.L78
	vmovss	4(%rdi,%rdx), %xmm0
	vaddss	4(%rsi,%rdx), %xmm0, %xmm0
	leal	2(%rax), %r8d
	vmovss	%xmm0, 4(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L78
	vmovss	8(%rdi,%rdx), %xmm0
	vaddss	8(%rsi,%rdx), %xmm0, %xmm0
	leal	3(%rax), %r8d
	vmovss	%xmm0, 8(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L78
	vmovss	12(%rdi,%rdx), %xmm0
	vaddss	12(%rsi,%rdx), %xmm0, %xmm0
	leal	4(%rax), %r8d
	vmovss	%xmm0, 12(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L78
	vmovss	16(%rdi,%rdx), %xmm0
	vaddss	16(%rsi,%rdx), %xmm0, %xmm0
	leal	5(%rax), %r8d
	vmovss	%xmm0, 16(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L78
	vmovss	20(%rdi,%rdx), %xmm0
	vaddss	20(%rsi,%rdx), %xmm0, %xmm0
	addl	$6, %eax
	vmovss	%xmm0, 20(%r9,%rdx)
	cmpl	%eax, %ecx
	jle	.L78
	vmovss	24(%rdi,%rdx), %xmm0
	vaddss	24(%rsi,%rdx), %xmm0, %xmm0
	vmovss	%xmm0, 24(%r9,%rdx)
	vzeroupper
.L79:
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L78:
	.cfi_restore_state
	vzeroupper
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L57:
	.cfi_restore_state
	vmovss	(%rdi,%r11,4), %xmm0
	vaddss	(%rsi,%r11,4), %xmm0, %xmm0
	leal	1(%rax), %r10d
	vmovss	%xmm0, (%rbx)
	cmpl	%r10d, %ecx
	jle	.L79
	vmovss	0(%r13), %xmm0
	vaddss	(%r8), %xmm0, %xmm0
	leal	2(%rax), %r8d
	vmovss	%xmm0, 4(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	8(%rdi,%rdx), %xmm0
	vaddss	8(%rsi,%rdx), %xmm0, %xmm0
	leal	3(%rax), %r8d
	vmovss	%xmm0, 8(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	12(%rdi,%rdx), %xmm0
	vaddss	12(%rsi,%rdx), %xmm0, %xmm0
	leal	4(%rax), %r8d
	vmovss	%xmm0, 12(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	16(%rdi,%rdx), %xmm0
	vaddss	16(%rsi,%rdx), %xmm0, %xmm0
	leal	5(%rax), %r8d
	vmovss	%xmm0, 16(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	20(%rdi,%rdx), %xmm0
	vaddss	20(%rsi,%rdx), %xmm0, %xmm0
	leal	6(%rax), %r8d
	vmovss	%xmm0, 20(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	24(%rdi,%rdx), %xmm0
	vaddss	24(%rsi,%rdx), %xmm0, %xmm0
	leal	7(%rax), %r8d
	vmovss	%xmm0, 24(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	28(%rdi,%rdx), %xmm0
	vaddss	28(%rsi,%rdx), %xmm0, %xmm0
	leal	8(%rax), %r8d
	vmovss	%xmm0, 28(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	32(%rdi,%rdx), %xmm0
	vaddss	32(%rsi,%rdx), %xmm0, %xmm0
	leal	9(%rax), %r8d
	vmovss	%xmm0, 32(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	36(%rdi,%rdx), %xmm0
	vaddss	36(%rsi,%rdx), %xmm0, %xmm0
	leal	10(%rax), %r8d
	vmovss	%xmm0, 36(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	40(%rdi,%rdx), %xmm0
	vaddss	40(%rsi,%rdx), %xmm0, %xmm0
	leal	11(%rax), %r8d
	vmovss	%xmm0, 40(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	44(%rdi,%rdx), %xmm0
	vaddss	44(%rsi,%rdx), %xmm0, %xmm0
	leal	12(%rax), %r8d
	vmovss	%xmm0, 44(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	48(%rdi,%rdx), %xmm0
	vaddss	48(%rsi,%rdx), %xmm0, %xmm0
	leal	13(%rax), %r8d
	vmovss	%xmm0, 48(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	52(%rdi,%rdx), %xmm0
	vaddss	52(%rsi,%rdx), %xmm0, %xmm0
	leal	14(%rax), %r8d
	vmovss	%xmm0, 52(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L79
	vmovss	56(%rdi,%rdx), %xmm0
	vaddss	56(%rsi,%rdx), %xmm0, %xmm0
	addl	$15, %eax
	vmovss	%xmm0, 56(%r9,%rdx)
	cmpl	%eax, %ecx
	jle	.L79
	vmovss	60(%rdi,%rdx), %xmm0
	vaddss	60(%rsi,%rdx), %xmm0, %xmm0
	vmovss	%xmm0, 60(%r9,%rdx)
	jmp	.L79
	.p2align 4,,10
	.p2align 3
.L63:
	.cfi_def_cfa 7, 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	xorl	%eax, %eax
	cmpl	%eax, %ecx
	jg	.L84
.L81:
	ret
.L64:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	xorl	%edx, %edx
	jmp	.L58
	.cfi_endproc
.LFE5514:
	.size	vector_add_avx512, .-vector_add_avx512
	.p2align 4
	.globl	vector_add
	.type	vector_add, @function
vector_add:
.LFB5515:
	.cfi_startproc
	endbr64
	movq	%rdx, %r9
	cmpl	$15, %ecx
	jle	.L94
	leal	-16(%rcx), %eax
	andl	$-16, %eax
	addl	$16, %eax
	cmpl	%eax, %ecx
	jle	.L112
.L115:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movslq	%eax, %r11
	movl	%ecx, %r10d
	leaq	0(,%r11,4), %rdx
	subl	%eax, %r10d
	leaq	4(%rdx), %r8
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r15
	pushq	%r14
	pushq	%r13
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	leaq	(%rdi,%r8), %r13
	addq	%rsi, %r8
	pushq	%r12
	.cfi_offset 12, -48
	leal	-1(%r10), %r12d
	pushq	%rbx
	.cfi_offset 3, -56
	leaq	(%r9,%rdx), %rbx
	movq	%rbx, %r14
	subq	%r13, %r14
	cmpq	$56, %r14
	movq	%rbx, %r14
	seta	%r15b
	subq	%r8, %r14
	cmpq	$56, %r14
	seta	%r14b
	testb	%r14b, %r15b
	je	.L88
	cmpl	$6, %r12d
	jbe	.L88
	cmpl	$14, %r12d
	jbe	.L95
	vmovups	(%rdi,%r11,4), %zmm2
	vaddps	(%rsi,%r11,4), %zmm2, %zmm0
	movl	%r10d, %edx
	andl	$-16, %edx
	addl	%edx, %eax
	vmovups	%zmm0, (%rbx)
	cmpl	%edx, %r10d
	je	.L109
	subl	%edx, %r10d
	leal	-1(%r10), %r8d
	cmpl	$6, %r8d
	jbe	.L91
.L89:
	addq	%r11, %rdx
	vmovups	(%rdi,%rdx,4), %ymm1
	vaddps	(%rsi,%rdx,4), %ymm1, %ymm0
	vmovups	%ymm0, (%r9,%rdx,4)
	movl	%r10d, %edx
	andl	$-8, %edx
	addl	%edx, %eax
	cmpl	%edx, %r10d
	je	.L109
.L91:
	movslq	%eax, %r8
	vmovss	(%rdi,%r8,4), %xmm0
	vaddss	(%rsi,%r8,4), %xmm0, %xmm0
	leaq	0(,%r8,4), %rdx
	vmovss	%xmm0, (%r9,%r8,4)
	leal	1(%rax), %r8d
	cmpl	%r8d, %ecx
	jle	.L109
	vmovss	4(%rdi,%rdx), %xmm0
	vaddss	4(%rsi,%rdx), %xmm0, %xmm0
	leal	2(%rax), %r8d
	vmovss	%xmm0, 4(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L109
	vmovss	8(%rdi,%rdx), %xmm0
	vaddss	8(%rsi,%rdx), %xmm0, %xmm0
	leal	3(%rax), %r8d
	vmovss	%xmm0, 8(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L109
	vmovss	12(%rdi,%rdx), %xmm0
	vaddss	12(%rsi,%rdx), %xmm0, %xmm0
	leal	4(%rax), %r8d
	vmovss	%xmm0, 12(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L109
	vmovss	16(%rdi,%rdx), %xmm0
	vaddss	16(%rsi,%rdx), %xmm0, %xmm0
	leal	5(%rax), %r8d
	vmovss	%xmm0, 16(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L109
	vmovss	20(%rdi,%rdx), %xmm0
	vaddss	20(%rsi,%rdx), %xmm0, %xmm0
	addl	$6, %eax
	vmovss	%xmm0, 20(%r9,%rdx)
	cmpl	%eax, %ecx
	jle	.L109
	vmovss	24(%rdi,%rdx), %xmm0
	vaddss	24(%rsi,%rdx), %xmm0, %xmm0
	vmovss	%xmm0, 24(%r9,%rdx)
	vzeroupper
.L110:
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L109:
	.cfi_restore_state
	vzeroupper
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
	.p2align 4,,10
	.p2align 3
.L88:
	.cfi_restore_state
	vmovss	(%rdi,%r11,4), %xmm0
	vaddss	(%rsi,%r11,4), %xmm0, %xmm0
	leal	1(%rax), %r10d
	vmovss	%xmm0, (%rbx)
	cmpl	%r10d, %ecx
	jle	.L110
	vmovss	0(%r13), %xmm0
	vaddss	(%r8), %xmm0, %xmm0
	leal	2(%rax), %r8d
	vmovss	%xmm0, 4(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	8(%rdi,%rdx), %xmm0
	vaddss	8(%rsi,%rdx), %xmm0, %xmm0
	leal	3(%rax), %r8d
	vmovss	%xmm0, 8(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	12(%rdi,%rdx), %xmm0
	vaddss	12(%rsi,%rdx), %xmm0, %xmm0
	leal	4(%rax), %r8d
	vmovss	%xmm0, 12(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	16(%rdi,%rdx), %xmm0
	vaddss	16(%rsi,%rdx), %xmm0, %xmm0
	leal	5(%rax), %r8d
	vmovss	%xmm0, 16(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	20(%rdi,%rdx), %xmm0
	vaddss	20(%rsi,%rdx), %xmm0, %xmm0
	leal	6(%rax), %r8d
	vmovss	%xmm0, 20(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	24(%rdi,%rdx), %xmm0
	vaddss	24(%rsi,%rdx), %xmm0, %xmm0
	leal	7(%rax), %r8d
	vmovss	%xmm0, 24(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	28(%rdi,%rdx), %xmm0
	vaddss	28(%rsi,%rdx), %xmm0, %xmm0
	leal	8(%rax), %r8d
	vmovss	%xmm0, 28(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	32(%rdi,%rdx), %xmm0
	vaddss	32(%rsi,%rdx), %xmm0, %xmm0
	leal	9(%rax), %r8d
	vmovss	%xmm0, 32(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	36(%rdi,%rdx), %xmm0
	vaddss	36(%rsi,%rdx), %xmm0, %xmm0
	leal	10(%rax), %r8d
	vmovss	%xmm0, 36(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	40(%rdi,%rdx), %xmm0
	vaddss	40(%rsi,%rdx), %xmm0, %xmm0
	leal	11(%rax), %r8d
	vmovss	%xmm0, 40(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	44(%rdi,%rdx), %xmm0
	vaddss	44(%rsi,%rdx), %xmm0, %xmm0
	leal	12(%rax), %r8d
	vmovss	%xmm0, 44(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	48(%rdi,%rdx), %xmm0
	vaddss	48(%rsi,%rdx), %xmm0, %xmm0
	leal	13(%rax), %r8d
	vmovss	%xmm0, 48(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	52(%rdi,%rdx), %xmm0
	vaddss	52(%rsi,%rdx), %xmm0, %xmm0
	leal	14(%rax), %r8d
	vmovss	%xmm0, 52(%r9,%rdx)
	cmpl	%r8d, %ecx
	jle	.L110
	vmovss	56(%rdi,%rdx), %xmm0
	vaddss	56(%rsi,%rdx), %xmm0, %xmm0
	addl	$15, %eax
	vmovss	%xmm0, 56(%r9,%rdx)
	cmpl	%eax, %ecx
	jle	.L110
	vmovss	60(%rdi,%rdx), %xmm0
	vaddss	60(%rsi,%rdx), %xmm0, %xmm0
	vmovss	%xmm0, 60(%r9,%rdx)
	jmp	.L110
	.p2align 4,,10
	.p2align 3
.L94:
	.cfi_def_cfa 7, 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	.cfi_restore 13
	.cfi_restore 14
	.cfi_restore 15
	xorl	%eax, %eax
	cmpl	%eax, %ecx
	jg	.L115
.L112:
	ret
.L95:
	.cfi_def_cfa 6, 16
	.cfi_offset 3, -56
	.cfi_offset 6, -16
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -24
	xorl	%edx, %edx
	jmp	.L89
	.cfi_endproc
.LFE5515:
	.size	vector_add, .-vector_add
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC1:
	.string	"[ "
.LC2:
	.string	"%f "
.LC3:
	.string	"]"
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB5516:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	.LC1(%rip), %rsi
	movl	$1, %edi
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%r13
	pushq	%r12
	pushq	%r10
	pushq	%rbx
	subq	$80, %rsp
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 10, -40
	.cfi_offset 3, -48
	vmovaps	.LC0(%rip), %zmm0
	movq	%fs:40, %rax
	movq	%rax, -40(%rbp)
	xorl	%eax, %eax
	vmovups	%zmm0, -112(%rbp)
	vzeroupper
	call	__printf_chk@PLT
	leaq	-112(%rbp), %rbx
	leaq	-48(%rbp), %r13
	leaq	.LC2(%rip), %r12
	.p2align 4,,10
	.p2align 3
.L117:
	vxorpd	%xmm1, %xmm1, %xmm1
	movq	%r12, %rsi
	movl	$1, %edi
	movl	$1, %eax
	vcvtss2sd	(%rbx), %xmm1, %xmm0
	call	__printf_chk@PLT
	addq	$4, %rbx
	cmpq	%r13, %rbx
	jne	.L117
	leaq	.LC3(%rip), %rdi
	call	puts@PLT
	movq	-40(%rbp), %rax
	subq	%fs:40, %rax
	jne	.L121
	addq	$80, %rsp
	xorl	%eax, %eax
	popq	%rbx
	popq	%r10
	popq	%r12
	popq	%r13
	popq	%rbp
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L121:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE5516:
	.size	main, .-main
	.section	.rodata
	.align 64
.LC0:
	.long	1065353216
	.long	1073741824
	.long	1082130432
	.long	1090519040
	.long	1065353216
	.long	1073741824
	.long	1082130432
	.long	1090519040
	.long	1065353216
	.long	1073741824
	.long	1082130432
	.long	1090519040
	.long	1065353216
	.long	1073741824
	.long	1082130432
	.long	1090519040
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
